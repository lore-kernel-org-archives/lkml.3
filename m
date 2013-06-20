Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3FTMqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:46:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44767 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab3FTMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:46:44 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm
Date: Thu, 20 Jun 2013 15:46:12 +0300
Message-ID: <1371732374-27191-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Patch 1 adds USB host support for beagle-XM.
Patch 2 cleans up pin comments for USB host pins.

Changes in v4:
- Rebased to todays for_3.11/dts branch
- added disclaimer about temporary usage of regulator framework for
GPIO RESET lines.

cheers,
-roger

Roger Quadros (2):
  ARM: dts: omap3-beagle-xm: Add USB Host support
  ARM: dts: omap3-beagle: Make USB host pin naming consistent

 arch/arm/boot/dts/omap3-beagle-xm.dts |   81 +++++++++++++++++++++++++++++----
 arch/arm/boot/dts/omap3-beagle.dts    |   29 +++++++-----
 2 files changed, 89 insertions(+), 21 deletions(-)

-- 
1.7.4.1

