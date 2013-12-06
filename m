Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162664Ab3LFXsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:48:25 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64329 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161630Ab3LFXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:48:21 -0500
X-IronPort-AV: E=Sophos;i="4.93,843,1378882800"; 
   d="scan'208";a="603049"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH 0/2] Enable I2C on bcm28155-ap
Date: Fri, 6 Dec 2013 15:45:26 -0800
Message-ID: <1386373528-13045-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables all the I2C busses on the bcm28155-ap board.

These patches appeared in another series that was partially accepted.
  https://lkml.org/lkml/2013/11/14/517

It depends on:  https://lkml.org/lkml/2013/12/5/508

Tim Kryger (2):
  ARM: dts: bcm281xx: Add i2c busses
  ARM: dts: bcm28155-ap: Enable all the i2c busses

 arch/arm/boot/dts/bcm11351.dtsi   | 40 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/bcm28155-ap.dts | 20 ++++++++++++++++++++
 2 files changed, 60 insertions(+)

-- 
1.8.0.1

