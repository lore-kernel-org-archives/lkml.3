Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3JLUrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:47:41 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:30801
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab3JLUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:47:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bh8275dhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <alex.williamson@redhat.com>, <r65777@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/3] Add maintainers entry for the Freescale PAMU driver.
Date: Sun, 13 Oct 2013 02:02:34 +0530
Message-ID: <1381609954-15283-4-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381609954-15283-1-git-send-email-Varun.Sethi@freescale.com>
References: <1381609954-15283-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a0cbf3..5b6ea5c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3511,6 +3511,13 @@ S:	Maintained
 F:	drivers/net/ethernet/freescale/fs_enet/
 F:	include/linux/fs_enet_pd.h
 
+FREESCALE PAMU DRIVER
+M:	Varun Sethi <varun.sethi@freescale.com>
+L:	linuxppc-dev@lists.ozlabs.org
+L:	iommu@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/iommu/fsl_pamu*
+
 FREESCALE QUICC ENGINE LIBRARY
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Orphan
-- 
1.7.9.5


