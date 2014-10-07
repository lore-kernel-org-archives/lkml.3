Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaJGVRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:17:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16472 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753806AbaJGVRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:17:01 -0400
Message-Id: <20141007211631.365194240@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 07 Oct 2014 17:16:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL] ktest: Updates for 3.18
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

A fix and a clean up to ktest, as well as two small features.

 A way to allow users to skip a manual bisect.
 Allowing cherry picked patches to be tested.

The cherry pick worked for a test I needed, but stressing it may
not have all the desired effects. It doesn't cause any regressions
so I kept it in.

Please pull the latest ktest-v3.18 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.18

Tag SHA1: 48c20121c5971c194410fa229d5797811a25a9e8
Head SHA1: d832d743385dd5e735660951aa9d7d36a6a4176a


Chris J Arges (1):
      ktest: add ability to skip during BISECT_MANUAL

Steven Rostedt (Red Hat) (3):
      ktest: Add PATCHCHECK_CHERRY
      ktest: Fix check for new kernel success on rebooting to good kernel
      ktest: Don't bother with bisect good or bad on replay

----
 tools/testing/ktest/ktest.pl    | 61 +++++++++++++++++++++++++++++++----------
 tools/testing/ktest/sample.conf | 10 +++++++
 2 files changed, 57 insertions(+), 14 deletions(-)
