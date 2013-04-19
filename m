Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3DSG3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56283 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3DSG2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] backlight: lp855x: cleanup the platform data and
 support the DT feature
Thread-Topic: [PATCH 0/5] backlight: lp855x: cleanup the platform data and
 support the DT feature
Thread-Index: Ac48xxnQ387kcV3JRjW/rEgJ71XNIg==
Date: Fri, 19 Apr 2013 06:28:28 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E56296@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set cleans up the platform data and supports the device tree feature.

Patch from 1 to 4: clean up the platform data and driver fixes.
Patch 5: support the DT structure.

Milo(Woogyom) Kim (5):
  backlight: lp855x: convert a type of device name
  backlight: lp855x: move backlight mode platform data
  backlight: lp855x: fix initial brightness type
  backlight: lp855x: remove duplicate platform data
  backlight: lp855x: add a device tree structure

 Documentation/backlight/lp855x-driver.txt          |    7 --
 .../devicetree/bindings/video/backlight/lp855x.txt |   43 +++++++++
 drivers/video/backlight/lp855x_bl.c                |   98 ++++++++++++++++++--
 include/linux/platform_data/lp855x.h               |   15 +--
 4 files changed, 133 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/lp855x.txt

-- 
1.7.9.5


Best Regards,
Milo

