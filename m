Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3EPEkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:40:52 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:6034
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab3EPEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:40:50 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 00:40:49 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz13e6Kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 append] mtd: update the ABI document about the ecc step
Date: Thu, 16 May 2013 12:09:43 +0800
Message-ID: <1368677383-29224-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368619642.15764.96.camel@sauron.fi.intel.com>
References: <1368619642.15764.96.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add a new sys node for ecc step. So update the ABI document about it.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 Documentation/ABI/testing/sysfs-class-mtd |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-mtd b/Documentation/ABI/testing/sysfs-class-mtd
index 3105644..62a1cda 100644
--- a/Documentation/ABI/testing/sysfs-class-mtd
+++ b/Documentation/ABI/testing/sysfs-class-mtd
@@ -173,3 +173,14 @@ Description:
 		This is generally applicable only to NAND flash devices with ECC
 		capability.  It is ignored on devices lacking ECC capability;
 		i.e., devices for which ecc_strength is zero.
+
+What:		/sys/class/mtd/mtdX/ecc_step
+Date:		May 2013
+KernelVersion:	3.10
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		The size of ecc step which is used for per ecc correction.
+		See more in the ecc_strength above. This will always be a
+		non-negative integer.
+
+		In the case of devices lacking any ECC capability, it is 0.
-- 
1.7.1


