Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaCFMn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:43:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50778 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaCFMn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:43:26 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <s.nawrocki@samsung.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 0/3] phy-omap-usb2 driver enhancements
Date: Thu, 6 Mar 2014 18:11:51 +0530
Message-ID: <1394109714-31228-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series 
	* Adds suport for AM437x USB2 PHY driver
	* Address DRA7 PHY errata for false disconnect
	* New compatible for OMAP5

Changelog v1 -> v2 
	* Refreshed the whole series on top of linux-phy/next
	* u32 flags changed to u8 flags in Patch1
	* changed devm_request_and ioremap to devm_ioremap_resource in Patch2

Austin Beam (1):
  phy: omap-usb2: Provide workaround for USB2PHY false disconnect

George Cherian (2):
  phy: omap-usb2: Adapt phy-omap-usb2 for AM437x
  phy: omap-usb2: Add different compatible for OMAP5

 Documentation/devicetree/bindings/usb/usb-phy.txt |   6 +-
 drivers/phy/phy-omap-usb2.c                       | 102 +++++++++++++++++++---
 include/linux/phy/omap_usb.h                      |  13 +++
 3 files changed, 108 insertions(+), 13 deletions(-)

-- 
1.8.3.1

