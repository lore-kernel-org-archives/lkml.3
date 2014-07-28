Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaG1GVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:21:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54422 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaG1GVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:21:39 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-patch-review@list.ti.com>
CC: <nm@ti.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <galak@codeaurora.org>, <lokeshvutla@ti.com>
Subject: [PATCH 0/2] ARM: dts: dra72-evm: Add i2c1 and tps65917 nodes 
Date: Mon, 28 Jul 2014 11:48:52 +0530
Message-ID: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series adds i2c1 and tps65917 and related nodes.
The patch series is boot tested on DRA72-EVM.

Thanks to Lokesh <lokeshvutla@ti.com> for testing the series.

Keerthy J (2):
  ARM: dts: dra72-evm: Enable I2C1 node
  ARM: dts: dra72-evm: Add tps65917 PMIC node

 arch/arm/boot/dts/dra72-evm.dts |  120 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

-- 
1.7.9.5

