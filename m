Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaAPKuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:50:39 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:26134
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbaAPKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:50:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob@landley.net>, <linux-doc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hongbo Zhang <hongbo.zhang@freescale.com>,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, <sumit.semwal@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH resend 1/2] Documentation: move all DMA documentations into Documentaion/dma
Date: Thu, 16 Jan 2014 18:50:04 +0800
Message-ID: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Since there are already seven DMA documentations under the top Documentation/,
it is better to create one dedicated directory for them.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: David S. Miller <davem@redhat.com>
Cc: Richard Henderson <rth@cygnus.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arthur Kepner <akepner@sgi.com>
Cc: sumit.semwal@linaro.org
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/{ => dma}/DMA-API-HOWTO.txt   |    0
 Documentation/{ => dma}/DMA-API.txt         |    0
 Documentation/{ => dma}/DMA-ISA-LPC.txt     |    0
 Documentation/{ => dma}/DMA-attributes.txt  |    0
 Documentation/{ => dma}/dma-buf-sharing.txt |    0
 Documentation/{ => dma}/dmaengine.txt       |    0
 Documentation/{ => dma}/dmatest.txt         |    0
 7 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{ => dma}/DMA-API-HOWTO.txt (100%)
 rename Documentation/{ => dma}/DMA-API.txt (100%)
 rename Documentation/{ => dma}/DMA-ISA-LPC.txt (100%)
 rename Documentation/{ => dma}/DMA-attributes.txt (100%)
 rename Documentation/{ => dma}/dma-buf-sharing.txt (100%)
 rename Documentation/{ => dma}/dmaengine.txt (100%)
 rename Documentation/{ => dma}/dmatest.txt (100%)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/dma/DMA-API-HOWTO.txt
similarity index 100%
rename from Documentation/DMA-API-HOWTO.txt
rename to Documentation/dma/DMA-API-HOWTO.txt
diff --git a/Documentation/DMA-API.txt b/Documentation/dma/DMA-API.txt
similarity index 100%
rename from Documentation/DMA-API.txt
rename to Documentation/dma/DMA-API.txt
diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/dma/DMA-ISA-LPC.txt
similarity index 100%
rename from Documentation/DMA-ISA-LPC.txt
rename to Documentation/dma/DMA-ISA-LPC.txt
diff --git a/Documentation/DMA-attributes.txt b/Documentation/dma/DMA-attributes.txt
similarity index 100%
rename from Documentation/DMA-attributes.txt
rename to Documentation/dma/DMA-attributes.txt
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma/dma-buf-sharing.txt
similarity index 100%
rename from Documentation/dma-buf-sharing.txt
rename to Documentation/dma/dma-buf-sharing.txt
diff --git a/Documentation/dmaengine.txt b/Documentation/dma/dmaengine.txt
similarity index 100%
rename from Documentation/dmaengine.txt
rename to Documentation/dma/dmaengine.txt
diff --git a/Documentation/dmatest.txt b/Documentation/dma/dmatest.txt
similarity index 100%
rename from Documentation/dmatest.txt
rename to Documentation/dma/dmatest.txt
-- 
1.7.9.5



