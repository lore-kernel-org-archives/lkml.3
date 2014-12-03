Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaLCVdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:33:38 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49502 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaLCVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:33:36 -0500
From: Marek Belisko <marek@goldelico.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, tony@atomide.com, bcousson@baylibre.com,
        hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v4 0/3] omapdss: Add video output support for gta04
Date: Wed,  3 Dec 2014 22:33:19 +0100
Message-Id: <1417642402-20538-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes from v3:
- use GPL v2 instead GPL
- fix wrong gpios property name in doc and DT
- set gpio to NULL if invalid
- drop unnecessary header

changes from v2:
- rename amplifier-opa362.c to encoder-opa362
- drop inversion handlign from driver
- add ti,invert-polarity to venc node

I also drop devconf1 handling patches because discussion how to
properly implement is not yet finished and this part is independent
from video driver.

changes from v1:
- fix opa362 compilation error
- fix opa362 DT documentation
- move devconf1 definition to omap3.dtsi
Marek Belisko (3):
  video: omapdss: Add opa362 driver
  Documentation: DT: Add documentation for ti,opa362 bindings
  arm: dts: omap3-gta04: Add handling for tv output

 .../devicetree/bindings/video/ti,opa362.txt        |  38 +++
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  49 ++++
 drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
 drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
 .../fbdev/omap2/displays-new/encoder-opa362.c      | 285 +++++++++++++++++++++
 5 files changed, 379 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.txt
 create mode 100644 drivers/video/fbdev/omap2/displays-new/encoder-opa362.c

-- 
1.9.1

