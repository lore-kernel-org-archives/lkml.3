Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab3BTEjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:39:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab3BTEju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:39:50 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] backlight: lp855x_bl: support new LP8557 device
Thread-Topic: [PATCH 0/3] backlight: lp855x_bl: support new LP8557 device
Thread-Index: Ac4PJEhiGIP3WDRuTzicSAtSf+gu6g==
Date: Wed, 20 Feb 2013 04:39:35 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792735B6@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support new device LP8557, LP855x device initialization process should be
changed.
This patch-set enables re-designing LP855x driver architecture and
supporting LP8557 device.

Milo(Woogyom) Kim (3):
  backlight: lp855x_bl: introduce device configuration flow
  backlight: lp855x_bl: support new LP8557 device
  backlight: lp855x_bl: simplify bl_get_brightness()

 Documentation/backlight/lp855x-driver.txt |    4 +-
 drivers/video/backlight/Kconfig           |    2 +-
 drivers/video/backlight/lp855x_bl.c       |  169 ++++++++++++++++++++++-------
 include/linux/platform_data/lp855x.h      |   19 ++++
 4 files changed, 152 insertions(+), 42 deletions(-)

-- 
1.7.9.5


Best Regards,
Milo


