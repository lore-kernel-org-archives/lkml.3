Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3IVIUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:20:18 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58877 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3IVIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:20:16 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH 0/3] iio: ti_am335x_adc: small fix and cleanup
Date: Sun, 22 Sep 2013 13:20:02 +0500
Message-Id: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These apply on togreg branch.

Fix/cleanup the am335x-adc driver.

1. Autobuilder picked up a missing static in function header
2. Trigger related code is redundant as driver is not using it
3. An error case that I could not figure out does what and why. 
Seemed like debug code to me. Removed it. ADC works without it.

Thanks
Zubair

Zubair Lutfullah (3):
  iio: ti_am335x_adc: fix static in function header
  iio: ti_am335x_adc: cleanup trigger related code
  iio: ti_am335x_adc: cleanup error case

 drivers/iio/adc/ti_am335x_adc.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

-- 
1.7.9.5

