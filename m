Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaJFPgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:36:37 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18777 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbaJFPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwNAEC2MlRXQzrG/2dsb2JhbABfgw65MQoBBQFzmmeBBRcBe4RgI4EaiHkBsluOT4YgiiUdhDUFnT6MUokug2U7gnkBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, iss_storagedev@hp.com,
        linux-edac@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/7 linux-next] drivers: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:47 +0200
Message-Id: <1412609755-28627-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset removes IRQF_DISABLED from drivers branch.

See include/linux/interrupt.h:
"This flag is a NOOP and scheduled to be removed"

Note: (cross)compiled but untested.

Fabian Frederick (7):
  mv64x60_edac: remove deprecated IRQF_DISABLED
  ppc4xx_edac: remove deprecated IRQF_DISABLED
  tw68: remove deprecated IRQF_DISABLED
  cpqarray: remove deprecated IRQF_DISABLED
  HSI: remove deprecated IRQF_DISABLED
  bus: omap_l3_noc: remove deprecated IRQF_DISABLED
  bus: omap_l3_smx: remove deprecated IRQF_DISABLED

 drivers/block/cpqarray.c           |  2 +-
 drivers/bus/omap_l3_noc.c          |  4 ++--
 drivers/bus/omap_l3_smx.c          | 10 ++++------
 drivers/edac/mv64x60_edac.c        |  8 ++++----
 drivers/edac/ppc4xx_edac.c         |  4 ++--
 drivers/hsi/clients/nokia-modem.c  |  4 ++--
 drivers/media/pci/tw68/tw68-core.c |  2 +-
 7 files changed, 16 insertions(+), 18 deletions(-)

-- 
1.9.3

