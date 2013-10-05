Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3JEPTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:19:00 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:58856 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab3JEPS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:18:58 -0400
From: oliver+list@schinagl.nl
To: rob.herring@calxeda.com, maxime.ripard@free-electrons.com,
        oliver@schinagl.nl, pawel.moll@arm.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Cc: devicetree@vger.kernel.org, dev@linux-sunxi.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Oliver Schinagl <oliver+list@schinagl.nl>
Subject: [PATCH] ARM: sunxi: dts: preliminary cubietruck support
Date: Sat,  5 Oct 2013 17:17:26 +0200
Message-Id: <1380986247-29112-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver+list@schinagl.nl>

A new cubieboard has been introduced, the cubietruck. I did try to also add emac support, but that didn't work well with the included RTL8211E Gbit PHY so I ommited that for now (it doesn't work with u-boot either).

I tested the uart0 port and the LEDS which all seemed to work as expected.

Oliver Schinagl (1):
  ARM: sunxi: dts: Add support for the cubieboard3, the CubieTruck

 arch/arm/boot/dts/Makefile                 |  1 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 60 ++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-cubietruck.dts

-- 
1.8.1.5

