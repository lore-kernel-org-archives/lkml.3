Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3FJJGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:06:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49171 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3FJJGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:06:16 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <b-cousson@ti.com>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>, <swarren@nvidia.com>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <lee.jones@linaro.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 0/2]  ARM: dts: Add palmas dtsi 
Date: Mon, 10 Jun 2013 14:34:17 +0530
Message-ID: <1370855059-5342-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds palmas.dtsi and adds the omap5 specific palmas
entries in the omap5-uevm board file.

This patch series is based on:

git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
for_3.11/dts

Boot tested on omap5-uevm board.

J Keerthy (2):
  ARM: dts: add dtsi for palmas
  ARM: dts: OMAP5: add palmas node and omap specific palmas regulator
    properties

 arch/arm/boot/dts/omap5-uevm.dts |  147 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/palmas.dtsi    |   98 +++++++++++++++++++++++++
 2 files changed, 245 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/palmas.dtsi

-- 
1.7.5.4

