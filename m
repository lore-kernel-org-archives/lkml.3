Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3FJWUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:20:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41229 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484Ab3FJWUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:20:53 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] checkpatch: collection of neatenings and new "--fix"
Date: Mon, 10 Jun 2013 15:20:38 -0700
Message-Id: <cover.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few neatenings and cleanups and an EXPERIMENTAL option to
fix various whitespace/formatting defects in patches.

Joe Perches (12):
  checkpatch: Remove quote from CamelCase test
  checkpatch: Improve network block comment test and message
  checkpatch: Warn when networking block comment lines don't start with *
  checkpatch: Warn on comparisons to jiffies
  checkpatch: Warn on comparisons to get_jiffies_64()
  checkpatch: Reduce false positive rate of "complex macros"
  checkpatch: Add a placeholder to check blank lines before declarations
  checkpatch: Don't warn on blank lines before/after braces as often
  checkpatch: Add a --strict test for comparison to true/false
  checkpatch: Improve "no space after cast" test
  checkpatch: Create an EXPERIMENTAL --fix option to correct patches
  checkpatch: Move test for space before semicolon after operator spacing

 scripts/checkpatch.pl | 524 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 423 insertions(+), 101 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

