Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3CPBIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:08:54 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.197]:5341 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031Ab3CPBIx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:08:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1363396132!22354447!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] cleanup some arm/ep93xx drivers
Date: Fri, 15 Mar 2013 18:08:49 -0700
User-Agent: KMail/1.9.9
CC: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201303151808.49361.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple section mismatch warnings and convert two of the ep93xx
drivers to use module_platform_driver.

H Hartley Sweeten (3):
  backlight: ep93xx_bl: fix section mismatch
  video: ep93xx-fb.c: fix section mismatch and use module_platform_driver
  misc: ep93xx_pwm.c: fix section mismatch and use module_platform_driver

 drivers/misc/ep93xx_pwm.c           | 21 +++++----------------
 drivers/video/backlight/ep93xx_bl.c |  3 +--
 drivers/video/ep93xx-fb.c           | 18 +++---------------
 3 files changed, 9 insertions(+), 33 deletions(-)

-- 
1.8.1.4
