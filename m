Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3FGO5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:57:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:24145 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3FGO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:57:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 0/2] dmaengine: at_hdmac: dt dma bindings update
Date: Fri, 7 Jun 2013 16:57:03 +0200
Message-ID: <cover.1370615665.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod,

This is the patch series that has already been sent by Ludovic. It is the part
of the series that is dedicated to dmaengine. It is based on slave-dma/next. I
plan to submit an additional patch through arm-soc as the .dtsi updates are
dependent on a "cleanup" branch that is already stacked there.

This set of patches update the dt dma binding for at_hdmac since we need one
more parameter. In order to keep backward compatibility, an existing cell will
be used to add this parameter. Since the content of that cell will become a
magic value due to the concatenation of the two parameters, it is time to
use macros.

Thanks, best regards,

Ludovic Desroches (2):
  ARM: at91: dt: add header to define at_hdmac configuration
  at_hdmac: add FIFO configuration parameter to DMA DT binding

 .../devicetree/bindings/dma/atmel-dma.txt          |  7 ++++--
 drivers/dma/at_hdmac.c                             | 25 ++++++++++++++++----
 include/dt-bindings/dma/at91.h                     | 27 ++++++++++++++++++++++
 3 files changed, 53 insertions(+), 6 deletions(-)
 create mode 100644 include/dt-bindings/dma/at91.h

-- 
1.8.2.2

