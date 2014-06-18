Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966292AbaFRMRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:17:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37325 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966020AbaFRMRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:17:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <paul@pwsan.com>
CC: <rnayak@ti.com>, <nm@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <balbi@ti.com>, <balajitk@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/2] ARM: DRA7: hwmod: fixes for 3.16
Date: Wed, 18 Jun 2014 15:16:54 +0300
Message-ID: <1403093816-10960-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add the missing OCP2SCP3 module and fixup the SATA hwmod
for DRA7 SoC. Both patches are tested on 3.16-rc1.

SATA should have worked on DRA7-evm with just these 2 patches on top of
3.16-rc1,but it didn't :(. So something else is missing and needs to be
investigated. SATA worked fine on omap5-uevm though so the problem is
DRA7 specific.

The patches are required for 3.16 in any case.

cheers,
-roger

Roger Quadros (2):
  ARM: DRA7: hwmod: Add OCP2SCP3 module
  ARM: DRA7: hwmod: Fixup SATA hwmod

 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

-- 
1.8.3.2

