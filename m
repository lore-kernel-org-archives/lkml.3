Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3A3Nrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:47:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58348 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3A3Nrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:47:49 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <santosh.shilimkar@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 0/2] add omap mcspi device tree data 
Date: Wed, 30 Jan 2013 19:18:53 +0530
Message-ID: <1359553733-12066-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch series adds omap5 evm mcspi nodes and pinctrl 
data in omap5.dtsi and omap5-evm.dts files.

Felipe Balbi (1):
  arm: dts: omap5: add SPI devices to OMAP5 DeviceTree file

Sourav Poddar (1):
  arm: dts: omap5-evm: Add mcspi data

 arch/arm/boot/dts/omap5-evm.dts |   46 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

