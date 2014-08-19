Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaHSPIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:08:45 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42424 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaHSPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:08:43 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/6] Add max77802 support for Peach boards
Date: Tue, 19 Aug 2014 17:08:27 +0200
Message-Id: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

Mark Brown has already queued for 3.18 the max77802 PMIC regulators
driver so now we can add support for these in the Peach Pit and Pi
DTS and also merge all the posted patches that depend on this. I've
picked all the patches I found and rebased them to be sure that they
apply cleanly on top of linux-next. Also I've taken some DT snippets
from the downstream Chrome OS 3.8 kernel DTS for devices that use
one of the regulators of these regulators has their input supply.

The series is composed of the following patches:

Javier Martinez Canillas (3):
  ARM: dts: Add Peach Pit and Pi dts entry for max77802 PMIC
  ARM: dts: Add vmmc and vqmmc supplies for Peach Pit and Pi boards
  ARM: dts: Add Peach Pit and Pi dts entry for ISL29018 sensor

Naveen Krishna Chatradhi (1):
  ARM: dts: Add thermistor dts fragment used by exynos based Peach
    boards

Rahul Sharma (2):
  ARM: dts: add hdmi regulators for exynos5800 based peach-pi board
  ARM: dts: add hdmi regulators for exynos5420 based peach-pit board

 arch/arm/boot/dts/cros-adc-thermistors.dtsi |  44 ++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts  | 390 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts   | 390 ++++++++++++++++++++++++++++
 3 files changed, 824 insertions(+)
 create mode 100644 arch/arm/boot/dts/cros-adc-thermistors.dtsi

Best regards,
Javier
