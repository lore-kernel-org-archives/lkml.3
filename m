Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbbAZSF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:05:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48307 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbbAZSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:05:26 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/2] gpio: sysfs: backports of memleak fixes to 3.12
Date: Mon, 26 Jan 2015 19:04:54 +0100
Message-Id: <1422295496-6194-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are backports of two fixes for memory leaks in the gpio sysfs
interface that are needed in the stable trees.

Tested on 3.12, but will not compile on 3.10 or earlier which lacks
device_create_with_groups. I'll send a second version for these kernels.

Johan


Johan Hovold (2):
  gpio: sysfs: fix gpio-chip device-attribute leak
  gpio: sysfs: fix gpio device-attribute leak

 drivers/gpio/gpiolib.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

-- 
2.0.5

