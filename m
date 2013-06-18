Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab3FRVcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:32:05 -0400
Received: from longford.logfs.org ([213.229.74.203]:59577 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab3FRVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:32:03 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>
Subject: [PATCH 0/3] Improve selftests
Date: Tue, 18 Jun 2013 16:01:58 -0400
Message-Id: <1371585721-28087-1-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First two are cleanups, third adds hugetlbfstest.  This test fails on
current kernels, but I have previously sent a patchset to fix the two
failures.

Joern Engel (3):
  selftests: exit 1 on failure
  self-test: fix make clean
  selftests: add hugetlbfstest

 tools/testing/selftests/vm/Makefile        |    7 ++-
 tools/testing/selftests/vm/hugetlbfstest.c |   84 ++++++++++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests     |   16 ++++++
 3 files changed, 104 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/vm/hugetlbfstest.c

-- 
1.7.10.4

