Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaCCKL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:11:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50038 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbaCCKLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:11:24 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <s.nawrocki@samsung.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH 0/3] phy-omap-usb2 driver enhancements
Date: Mon, 3 Mar 2014 15:40:21 +0530
Message-ID: <1393841424-27656-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series 
	* Adds suport for AM437x USB2 PHY driver
	* Address DRA7 PHY errata for false disconnect
	* New compatible for OMAP5

Austin Beam (1):
  phy: omap-usb2: Provide workaround for USB2PHY false disconnect

George Cherian (2):
  phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
  phy: omap-usb2: Add different compatible for OMAP5

 Documentation/devicetree/bindings/usb/usb-phy.txt |   6 +-
 drivers/phy/phy-omap-usb2.c                       | 106 +++++++++++++++++++---
 include/linux/usb/omap_usb.h                      |  12 +++
 3 files changed, 111 insertions(+), 13 deletions(-)

-- 
1.8.3.1

