Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbbABPYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:24:30 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60135 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbABPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:24:28 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND 0/4] Small updates to Snow and Peach Pit/Pi DTS
Date: Fri,  2 Jan 2015 16:24:13 +0100
Message-Id: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

This series adds some DTS snippets that were missing in the mainline
Snow and Peach Pit/Pi Device Trees but are present in the downstream
ChromeOS kernel.

The series is composed of the following patches:

Javier Martinez Canillas (4):
  ARM: dts: Add power and lid GPIO keys pinctrl for exynos5250-snow
  ARM: dts: Add lid GPIO key device node for Peach boards
  ARM: dts: Set Peach boards USB WebCam regulators to always on
  ARM: dts: Configure regulators for suspend on exynos Peach boards

 arch/arm/boot/dts/exynos5250-snow.dts      |  16 +++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 100 +++++++++++++++++++++++++++-
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 101 ++++++++++++++++++++++++++++-
 3 files changed, 215 insertions(+), 2 deletions(-)

Patch #1 adds some pinctrl lines for the GPIO keys in the Snow DTS.

Patch #2 adds a device node and pinctrl lines for the lid GPIO in
the Peach boards DTS.

Patch #3 sets the regulators that supply voltage to the USB WebCam
in Peach boards as always on.

Patch #4 configures the max77802 regulators on the Peach Pit and Pi
boards to be enabled or disabled during system suspend.

Best regards,
Javier

