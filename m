Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaEVVAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:00:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33028 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaEVVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:00:18 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/5] ks8851 DT updates
Date: Thu, 22 May 2014 14:00:08 -0700
Message-Id: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches properly documents the micrel ks8851 spi ethernet
controller, converts to devm_regulator_get_optional() to make error
paths slightly simpler, and finally adds supports for another
optional regulator and a reset gpio.

Stephen Boyd (5):
  devicetree: bindings: Document micrel vendor prefix
  devicetree: bindings: Properly document micrel ks8851 SPI chips
  net: ks8851: Use devm_regulator_get_optional()
  net: ks8851: Add optional vdd_io regulator and reset gpio
  net: ks8851: Add of match table

 .../devicetree/bindings/net/micrel-ks8851.txt      | 15 ++++-
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/net/ethernet/micrel/ks8851.c               | 71 +++++++++++++++++++---
 3 files changed, 75 insertions(+), 12 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

