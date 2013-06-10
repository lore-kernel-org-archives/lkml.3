Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FJG03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:26:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35652 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3FJGZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:25:57 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <b-cousson@ti.com>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>, <swarren@nvidia.com>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <lee.jones@linaro.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH 0/2] ARM: dts: Add palmas dtsi 
Date: Mon, 10 Jun 2013 11:52:13 +0530
Message-ID: <1370845335-14926-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds palmas.dtsi and adds the omap5
specific palmas entries in the omap5-uevm board file.

This patch series is based on:

        git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
        for_3.11/dts

Boot tested on omap5-uevm board.

J Keerthy (2):
  ARM: dts: add dtsi for palmas
  ARM: dts: OMAP5: add palmas node and omap specific palmas regulator
    properties

 arch/arm/boot/dts/omap5-uevm.dts |  145 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/palmas.dtsi    |   98 +++++++++++++++++++++++++
 2 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/palmas.dtsi

-- 
1.7.5.4

