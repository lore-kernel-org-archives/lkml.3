Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaG2XYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:24:47 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:46170 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaG2XYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:24:43 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: [PATCH 0/3] Enable EHCI port on rk3288-evb
Date: Tue, 29 Jul 2014 16:24:30 -0700
Message-Id: <1406676273-20701-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables the EHCI port on the rk3288-evb boards.  A later
patch series (from Kever) will enable the dwc2 ports.


Doug Anderson (3):
  ARM: dts: Turn on USB host vbus on rk3288-evb
  ARM: dts: add rk3288 ehci usb devices
  ARM: dts: Enable USB host0 (EHCI) on rk3288-evb

 arch/arm/boot/dts/rk3288-evb.dtsi | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/rk3288.dtsi     | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
2.0.0.526.g5318336

