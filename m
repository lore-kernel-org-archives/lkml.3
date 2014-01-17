Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaAQTWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:22:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaAQTWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:22:49 -0500
Date: Fri, 17 Jan 2014 11:22:27 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-fb09b78151361f5001ad462e4b242b10845830e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1389518403-7715-4-git-send-email-qiaowei.ren@intel.com>
References: <1389518403-7715-4-git-send-email-qiaowei.ren@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx:
  Add MPX related opcodes to the x86 opcode map
Git-Commit-ID: fb09b78151361f5001ad462e4b242b10845830e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 17 Jan 2014 11:22:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb09b78151361f5001ad462e4b242b10845830e2
Gitweb:     http://git.kernel.org/tip/fb09b78151361f5001ad462e4b242b10845830e2
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Sun, 12 Jan 2014 17:20:02 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Jan 2014 11:04:09 -0800

x86, mpx: Add MPX related opcodes to the x86 opcode map

This patch adds all the MPX instructions to x86 opcode map, so the x86
instruction decoder can decode MPX instructions.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/1389518403-7715-4-git-send-email-qiaowei.ren@intel.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/x86-opcode-map.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 533a85e..1a2be7c 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -346,8 +346,8 @@ AVXcode: 1
 17: vmovhps Mq,Vq (v1) | vmovhpd Mq,Vq (66),(v1)
 18: Grp16 (1A)
 19:
-1a:
-1b:
+1a: BNDCL Ev,Gv | BNDCU Ev,Gv | BNDMOV Gv,Ev | BNDLDX Gv,Ev,Gv
+1b: BNDCN Ev,Gv | BNDMOV Ev,Gv | BNDMK Gv,Ev | BNDSTX Ev,GV,Gv
 1c:
 1d:
 1e:
