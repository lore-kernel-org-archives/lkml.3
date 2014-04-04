Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaDDDYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:24:23 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53603
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbaDDDYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:24:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v4 0/2] i2c: add DMA support for freescale i2c driver 
Date: Fri, 4 Apr 2014 10:41:10 +0800
Message-ID: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changed in v4:
- cancelled "i2c_imx->use_dma".
- changed "Dma" to "DMA".
- add timeout handling  for DMA transfer complete.

Changed in v3:
- fix a bug when request the DMA faild.
- some minor fixes for coding style.
- other minor fixes.

Changed in v2:
- remove has_dma_support property
- unify i2c_imx_dma_rx and i2c_imx_dma_tx
- unify i2c_imx_dma_read and i2c_imx_pio_read
- unify i2c_imx_dma_write and i2c_imx_pio_write

Added in v1:
- Enable DMA if it's support DMA and transfer size bigger than the threshold.
- Add device tree bindings for i2c eDMA support.
- Add eDMA support for i2c driver.

