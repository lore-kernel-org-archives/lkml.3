Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaGCLB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:01:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37397 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGCLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:01:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>
CC: <rnayak@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/3] OMAP: dra7: hwmod: Fixes for 3.16
Date: Thu, 3 Jul 2014 14:01:11 +0300
Message-ID: <1404385274-5093-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For your convenience I have collected the 3 hwmod patches that were floating around
and added the Reviewed-by and Tested-by tags.

Please queue them for 3.16-rc. Thanks.

Patches are also available in my git tree
git@github.com:rogerq/linux.git		hwmod-v3.16-v2

cheers,
-roger

Roger Quadros (3):
  ARM: DRA7: hwmod: Add OCP2SCP3 module
  ARM: DRA7: hwmod: Fixup SATA hwmod
  ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss

 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 42 +++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

-- 
1.8.3.2

