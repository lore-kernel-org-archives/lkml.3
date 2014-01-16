Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaAPKug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:50:36 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:58073
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbaAPKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:50:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob@landley.net>, <linux-doc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hongbo Zhang <hongbo.zhang@freescale.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH resend 2/2] Documentation: update some DMA document texts due to relocation
Date: Thu, 16 Jan 2014 18:50:05 +0800
Message-ID: <1389869405-10363-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Some references to "Documentation/*" in the moved documentations should be
updated to "Documentation/dma/*" accordingly.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
---
 Documentation/dma/DMA-API.txt     |    6 +++---
 Documentation/dma/DMA-ISA-LPC.txt |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/dma/DMA-API.txt b/Documentation/dma/DMA-API.txt
index e865279..e4dc36c 100644
--- a/Documentation/dma/DMA-API.txt
+++ b/Documentation/dma/DMA-API.txt
@@ -5,7 +5,7 @@
 
 This document describes the DMA API.  For a more gentle introduction
 of the API (and actual examples) see
-Documentation/DMA-API-HOWTO.txt.
+Documentation/dma/DMA-API-HOWTO.txt.
 
 This API is split into two pieces.  Part I describes the API.  Part II
 describes the extensions to the API for supporting non-consistent
@@ -395,7 +395,7 @@ struct dma_attrs encapsulates a set of "dma attributes". For the
 definition of struct dma_attrs see linux/dma-attrs.h.
 
 The interpretation of dma attributes is architecture-specific, and
-each attribute should be documented in Documentation/DMA-attributes.txt.
+each attribute should be documented in Documentation/dma/DMA-attributes.txt.
 
 If struct dma_attrs* is NULL, the semantics of each of these
 functions is identical to those of the corresponding function
@@ -408,7 +408,7 @@ for DMA:
 
 #include <linux/dma-attrs.h>
 /* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
- * documented in Documentation/DMA-attributes.txt */
+ * documented in Documentation/dma/DMA-attributes.txt */
 ...
 
 	DEFINE_DMA_ATTRS(attrs);
diff --git a/Documentation/dma/DMA-ISA-LPC.txt b/Documentation/dma/DMA-ISA-LPC.txt
index e767805..e9b7a1c 100644
--- a/Documentation/dma/DMA-ISA-LPC.txt
+++ b/Documentation/dma/DMA-ISA-LPC.txt
@@ -16,7 +16,7 @@ To do ISA style DMA you need to include two headers:
 #include <asm/dma.h>
 
 The first is the generic DMA API used to convert virtual addresses to
-physical addresses (see Documentation/DMA-API.txt for details).
+physical addresses (see Documentation/dma/DMA-API.txt for details).
 
 The second contains the routines specific to ISA DMA transfers. Since
 this is not present on all platforms make sure you construct your
-- 
1.7.9.5



