Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbaJUObY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:31:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbaJUObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:31:19 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/3] ARM: dts: dra72-evm: Add MMC PMIC button information
Date: Tue, 21 Oct 2014 09:30:45 -0500
Message-ID: <1413901848-32268-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is based on 3.18-rc1 and enables palmas power button and
MMC (SD/EMMC) support. These could be queued for 3.19-rc1 considering
that these are not fixes, if it is not too late for additional
features for dts, might be nice to get them merged for 3.18 series.

Menon, Nishanth (1):
  ARM: dts: dra72-evm: Add MMC nodes

Nishanth Menon (2):
  ARM: dts: dra72-evm: Provide explicit pinmux for TPS PMIC
  ARM: dts: dra72-evm: Add power button node

 arch/arm/boot/dts/dra72-evm.dts |   76 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

-- 
1.7.9.5

Regards,
Nishanth Menon
