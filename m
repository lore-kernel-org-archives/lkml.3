Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaIKMaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:30:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:53795 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaIKMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:30:10 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 3.17-rc4 0/3] kdb: Improve command output searching
Date: Thu, 11 Sep 2014 13:29:36 +0100
Message-Id: <1410438579-7839-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset improves kdb's capabilities to search the output
of commands. Specifically it fixes a bug in the prompt management
when '| grep' is used and adds a new feature to search command
output interactively from the more prompt.


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

