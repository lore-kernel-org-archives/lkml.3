Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbbAZSGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:06:19 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45479 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbbAZSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:06:16 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/2] gpio: sysfs: backports of memleak fixes to 3.10
Date: Mon, 26 Jan 2015 19:05:58 +0100
Message-Id: <1422295560-6284-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422295496-6194-1-git-send-email-johan@kernel.org>
References: <1422295496-6194-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here are the backports of the two fixes for memory leaks in the gpio
sysfs interface for 3.10 and earlier.

Tested on 3.12 and compile-tested on 3.10.

Johan


Johan Hovold (2):
  gpio: sysfs: fix gpio-chip device-attribute leak
  gpio: sysfs: fix gpio device-attribute leak

 drivers/gpio/gpiolib.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

-- 
2.0.5

