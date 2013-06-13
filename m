Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab3FMIkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:40:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:48808 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3FMIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:40:11 -0400
From: <ludovic.desroches@atmel.com>
To: <vinod.koul@intel.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [PATCH v3 0/2] dmaengine: at_hdmac: dt dma bindings update
Date: Thu, 13 Jun 2013 10:39:37 +0200
Message-ID: <1371112779-22738-1-git-send-email-ludovic.desroches@atmel.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Vinod,

This version removes the extra tab in patch 2/2 and add Arnd's ack.


Thanks

Regards

Ludovic


This set of patches update the dt dma binding for at_hdmac since we need one
more parameter. In order to keep backward compatibility, an existing cell will
be used to add this parameter. Since the content of that cell will become a
magic value due to the concatenation of the two parameters, it is time to
use macros.

v3:
- remove extra tab in patch 2/2
v2:
- rebased on slave-dma/next


Ludovic Desroches (2):
  ARM: at91: dt: add header to define at_hdmac configuration
  at_hdmac: add FIFO configuration parameter to DMA DT binding

 .../devicetree/bindings/dma/atmel-dma.txt          |  7 ++++--
 drivers/dma/at_hdmac.c                             | 25 ++++++++++++++++----
 include/dt-bindings/dma/at91.h                     | 27 ++++++++++++++++++++++
 3 files changed, 53 insertions(+), 6 deletions(-)
 create mode 100644 include/dt-bindings/dma/at91.h

-- 
1.7.11.3

