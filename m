Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3GYNFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:05:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60198 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3GYNFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:05:39 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 0/3] Few ignored framebuffer fixes/additions
Date: Thu, 25 Jul 2013 15:05:10 +0200
Message-Id: <1374757513-2253-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the v2 of a set of patches that got forgotten.

These have been around for a while without any functionnal comments recently,
so I guess we should be pretty close to merge them.

It would be great if we could have comments from the maintainer on these
patches though.

Thanks,
Maxime

Changes from v1:
  - Fix line wrapping in patch 2
  - Added some comments on the msleep in patch 3

Alexandre Belloni (1):
  fb: backlight: HX8357: Add HX8369 support

Hector Palacios (1):
  video: mxsfb: fix color settings for 18bit data bus and 32bpp

Maxime Ripard (1):
  video: hx8357: Make IM pins optional

 drivers/video/backlight/hx8357.c | 272 +++++++++++++++++++++++++++++++++------
 drivers/video/mxsfb.c            |  26 ----
 2 files changed, 236 insertions(+), 62 deletions(-)

-- 
1.8.3.2

