Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3GDGYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:24:18 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:37265
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938Ab3GDGYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:24:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <mikey@neuling.org>,
        <benh@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <agraf@suse.de>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 1/2] powerpc: remove unnecessary line continuations
Date: Thu, 4 Jul 2013 11:45:45 +0530
Message-ID: <1372918546-15075-2-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index c517dbe..19b8733 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -325,7 +325,7 @@ static void set_debug_reg_defaults(struct thread_struct *thread)
 	/*
 	 * Force User/Supervisor bits to b11 (user-only MSR[PR]=1)
 	 */
-	thread->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |	\
+	thread->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |
 			DBCR1_IAC3US | DBCR1_IAC4US;
 	/*
 	 * Force Data Address Compare User/Supervisor bits to be User-only
-- 
1.7.0.4


