#!/usr/bin/env bash

gem install --no-document rubocop rubocop-checkstyle_formatter \
    rails_best_practices \
    reek \
    checkstyle_filter-git saddler saddler-reporter-github \

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

echo "********************"
echo "* save outputs     *"
echo "********************"
LINT_RESULT_DIR="$CIRCLE_ARTIFACTS/lint"

mkdir "$LINT_RESULT_DIR"
cp -v "rubocop.xml" "$LINT_RESULT_DIR/"
