Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3FMMxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:53:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35707 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3FMMxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:53:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 0/2] ARM: dts: Add USB host support for Beagle-xm
Date: Thu, 13 Jun 2013 15:53:15 +0300
Message-ID: <1371127997-8089-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds USB host support for Beagle-xm.

Roger Quadros (2):
  ARM: dts: omap3-beagle-xm: Add USB Host support
  ARM: dts: omap3-beagle: Make USB host pin naming consistent

 arch/arm/boot/dts/omap3-beagle-xm.dts |   61 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3-beagle.dts    |   24 ++++++------
 2 files changed, 73 insertions(+), 12 deletions(-)

-- 
1.7.4.1

