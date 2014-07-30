Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaG3UAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:00:24 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:48815 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaG3UAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:00:16 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: [PATCH v2 0/3] Enable EHCI port on rk3288-evb
Date: Wed, 30 Jul 2014 13:00:09 -0700
Message-Id: <1406750412-15592-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables the EHCI port on the rk3288-evb boards.  A later
patch series (from Kever) will enable the dwc2 ports.

Changes in v2:
- usb_host_vbus => vcc_host to match supply name, not pin name.
- pin name now matches in name in schematic
- Kever is now the author
- Node is now named usb

Doug Anderson (2):
  ARM: dts: Turn on USB host vbus on rk3288-evb
  ARM: dts: Enable USB host0 (EHCI) on rk3288-evb

Kever Yang (1):
  ARM: dts: add rk3288 ehci usb devices

 arch/arm/boot/dts/rk3288-evb.dtsi | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/rk3288.dtsi     | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
2.0.0.526.g5318336

