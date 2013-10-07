Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3JGN3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:29:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52892 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3JGN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:29:06 -0400
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <pavel@ucw.cz>, <aaro.koskinen@iki.fi>,
        <marek@goldelico.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/1] Possibly fix USB OTG on GTA04 and N900
Date: Mon, 7 Oct 2013 16:28:12 +0300
Message-ID: <1381152493-28055-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

USB OTG on these boards might be broken on Greg's usb-next branch [1]
after the Generic PHY framework and associated patches were merged.

This is a probable fix but I'm not able to test these boards. Please
give it a try and your Ack if it works. Thanks.

[1] - git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git

cheers,
-roger

Roger Quadros (1):
  ARM: dts: omap3:  Adapt USB OTG to generic PHY framework

 arch/arm/boot/dts/omap3-gta04.dts |    2 ++
 arch/arm/boot/dts/omap3-n900.dts  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

-- 
1.7.4.1

