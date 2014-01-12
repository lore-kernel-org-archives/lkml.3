Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaALCH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 21:07:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:44351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaALCHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 21:07:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,645,1384329600"; 
   d="scan'208";a="333643377"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 4/5] x86, mpx: add MPX related opcodes to the x86 opcode map
Date: Sun, 12 Jan 2014 17:20:02 +0800
Message-Id: <1389518403-7715-4-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds all the MPX instructions to x86 opcode map, and then
the x86 instruction decoder can decode MPX instructions used in kernel.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/lib/x86-opcode-map.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.7.1

