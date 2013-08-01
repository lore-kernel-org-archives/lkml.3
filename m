Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3HAIkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:40:55 -0400
Received: from up.free-electrons.com ([94.23.35.102]:52072 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754Ab3HAIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:40:46 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 0/3] Few ignored framebuffer fixes/additions
Date: Thu,  1 Aug 2013 10:40:34 +0200
Message-Id: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the v2 of a set of patches that got forgotten.

These have been around for a while without any functionnal comments recently,
so I guess we should be pretty close to merge them.

It would be great if we could have comments from the maintainer on these
patches though (three patches iterations and 41 days since last sign of life of
the maintainer).

Thanks,
Maxime

Changes from v2:
  - Few minor coding style fixes
  - Removed the useless msleep(100) in the hx8369 init function

Changes from v1:
  - Fix line wrapping in patch 2
  - Added some comments on the msleep in patch 3


Alexandre Belloni (1):
  fb: backlight: HX8357: Add HX8369 support

Hector Palacios (1):
  video: mxsfb: fix color settings for 18bit data bus and 32bpp

Maxime Ripard (1):
  video: hx8357: Make IM pins optional

 drivers/video/backlight/hx8357.c | 269 ++++++++++++++++++++++++++++++++++-----
 drivers/video/mxsfb.c            |  26 ----
 2 files changed, 234 insertions(+), 61 deletions(-)

-- 
1.8.3.4

