Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3EUOHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:07:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60885 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3EUOHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:07:03 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linus.walleij@linaro.org>
CC: <nsekhar@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <prabhakar.csengg@gmail.com>, <peter.ujfalusi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH 0/3] pinctrl: pinctrl-single: Add full fledge support to configure multiple pins of different modules
Date: Tue, 21 May 2013 19:37:58 +0530
Message-ID: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based function-mask and submask preoperties patch allocates and registers pins.
Patch is fixes the issue reported and discussed here:
http://www.spinics.net/lists/arm-kernel/msg235213.html

Applies on top of 3.10-rc2 of linus's tree.

Tested on da850-evm.

Manjunathappa, Prakash (3):
  pinctrl: pinctrl-single: enhance to configure multiple pins of
    different     modules
  pinctrl: pinctrl-single: pin names for pinctrl-single.bits
  ARM: davinci: da850: adopt to pinctrl-single driver to configure
    multiple     pins

 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    3 +-
 arch/arm/boot/dts/da850.dtsi                       |    2 +-
 drivers/pinctrl/pinctrl-single.c                   |  215 ++++++++++++++++----
 3 files changed, 179 insertions(+), 41 deletions(-)

-- 
1.7.4.1

