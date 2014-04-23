Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbaDWRav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:30:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41515 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666AbaDWRaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:30:46 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 0/4] ARM: OMAP: SATA support for OMAP5 & DRA7
Date: Wed, 23 Apr 2014 20:30:33 +0300
Message-ID: <1398274237-24510-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

These are the pending HWMOD and DTS patches to get SATA working
on OMAP5-uevm and DRA7-evm. Please queue them for -next. Thanks.

cheers,
-roger

---
Balaji T K (2):
  ARM: dts: omap5: add sata node
  ARM: dts: dra7: add OCP2SCP3 and SATA nodes

Keshava Munegowda (1):
  ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods

Nikhil Devshatwar (1):
  ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods

 arch/arm/boot/dts/dra7.dtsi                | 39 ++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi               | 40 ++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 73 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c  | 31 +++++++++++--
 4 files changed, 178 insertions(+), 5 deletions(-)

-- 
1.8.3.2

