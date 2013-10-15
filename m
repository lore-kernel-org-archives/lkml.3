Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3JOKiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:38:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38570 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3JOKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:38:05 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/2] Adapt phy-omap-usb2 for AM437x platform
Date: Tue, 15 Oct 2013 16:07:41 +0530
Message-ID: <1381833463-12149-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adapts the phy-omap-usb2 generic phy driver for AM437x.
While at that sort the include files alphabetically (PATCH 1)
Patch1 - v2->v3 Amend the commit log

V2 of 2nd Patch which fixes the following from v1
	- List comaptible entries in Documentaion
	- Add usb_phy_data instead of checking compatible each time.

George Cherian (2):
  phy: omap-usb2: Sort the headers alphabetically
  phy: omap-usb2: Adapt phy-omap-usb2 for AM437x

 Documentation/devicetree/bindings/usb/usb-phy.txt |  4 +-
 drivers/phy/phy-omap-usb2.c                       | 72 +++++++++++++++--------
 include/linux/usb/omap_usb.h                      | 10 ++++
 3 files changed, 62 insertions(+), 24 deletions(-)

-- 
1.8.1

