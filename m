Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaDAKhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:37:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47589 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaDAKhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:37:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/1] OMAP5: USB3 fix for 3.15
Date: Tue, 1 Apr 2014 13:37:26 +0300
Message-ID: <1396348647-11545-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

The following patch fixes USB3 on OMAP5 on linux-next.
There was a patch [1] that added named clocks to the USB3 phy driver
but somehow the dts part got missed out.

Due to that USB3 on OMAP5 is currently broken on linux-next and
this patch should fix it.

cheers,
-roger

[1] - http://patchwork.ozlabs.org/patch/327481/

Roger Quadros (1):
  ARM: dts: omap5: Add clocks to USB3 PHY node

 arch/arm/boot/dts/omap5.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
1.8.3.2

