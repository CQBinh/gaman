#!/usr/bin/env bash

gem install --no-document rubocop rubocop-checkstyle_formatter \
    rails_best_practices \
    brakeman brakeman_translate_checkstyle_format \
    reek \
    checkstyle_filter-git saddler saddler-reporter-github \
    scss_lint scss_lint_reporter_checkstyle

npm install -g eslint

if [ -z "${CI_PULL_REQUEST}" ]; then
    # when not pull request
    REPORTER=Saddler::Reporter::Github::CommitReviewComment
else
    REPORTER=Saddler::Reporter::Github::PullRequestReviewComment
fi

echo "********************"
echo "* RuboCop          *"
echo "********************"
rubocop --require `gem which rubocop/formatter/checkstyle_formatter` --format RuboCop::Formatter::CheckstyleFormatter --out rubocop.xml
cat rubocop.xml \
  | checkstyle_filter-git diff origin/master \
  | saddler report \
    --require saddler/reporter/github \
    --reporter $REPORTER

echo "***********************"
echo "* Rails Best Pratices *"
echo "***********************"
rails_best_practices -f xml

cat rails_best_practices_output.xml \
  | checkstyle_filter-git diff origin/master \
  | saddler report \
    --require saddler/reporter/github \
    --reporter $REPORTER

echo "********************"
echo "* Brakeman         *"
echo "********************"
brakeman -o brakeman.json
cat brakeman.json \
  | brakeman_translate_checkstyle_format translate \
  | checkstyle_filter-git diff origin/master \
  | saddler report \
    --require saddler/reporter/github \
    --reporter $REPORTER


echo "********************"
echo "* Reek             *"
echo "********************"
reek app --format xml > reek.xml
cat reek.xml \
  | checkstyle_filter-git diff origin/master \
  | saddler report \
    --require saddler/reporter/github \
    --reporter $REPORTER

echo "********************"
echo "* save outputs     *"
echo "********************"
LINT_RESULT_DIR="$CIRCLE_ARTIFACTS/lint"

mkdir "$LINT_RESULT_DIR"
cp -v "rubocop.xml" "$LINT_RESULT_DIR/"
cp -v "rails_best_practices_output.xml" "$LINT_RESULT_DIR/"
cp -v "brakeman.json" "$LINT_RESULT_DIR/"
cp -v "reek.xml" "$LINT_RESULT_DIR/"
