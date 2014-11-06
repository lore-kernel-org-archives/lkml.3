Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKFQCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:02:48 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45989 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:02:47 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH 3.18-rc3 0/3] kdb: Improve command output searching
Date: Thu,  6 Nov 2014 16:02:23 +0000
Message-Id: <1415289746-30917-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
References: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset improves kdb's capabilities to search the output of
commands.

Specifically it fixes a bug in the prompt management when '| grep' is
used and adds a new feature to search command output interactively from
the more prompt. Finally there is a trivial bit of const clean up that I
spotted when implementing the other two patches.


Daniel Thompson (3):
  kdb: Fix a prompt management bug when using | grep
  kdb: Provide forward search at more prompt
  kdb: Const qualifier for kdb_getstr's prompt argument

 kernel/debug/kdb/kdb_io.c      | 24 +++++++++++++++++++++---
 kernel/debug/kdb/kdb_main.c    | 11 ++++++-----
 kernel/debug/kdb/kdb_private.h |  4 +++-
 3 files changed, 30 insertions(+), 9 deletions(-)

--
1.9.3

