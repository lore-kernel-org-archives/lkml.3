Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967931Ab3HIPdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:33:15 -0400
Received: from mout.gmx.net ([212.227.15.15]:53784 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059Ab3HIPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:33:11 -0400
Date: Fri, 9 Aug 2013 17:33:06 +0200
From: Michael Brunner <mibru@gmx.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: [PATCH] gpio: Fix platform driver name in Kontron PLD GPIO driver
Message-ID: <20130809173306.1ba24b59@mail.gmx.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:DPyqE9hb8/eEQnqTjH7KZgN3u8SgsyIyCXGQEWCrwJ6TDdOYO1K
 BPML4mar6K2kpZpdX/GriGLHia4xMvRc3tATSIVnxtEcTbfe+AQI4357UdUMR+i5QLd3ETe
 /dMfmFNeeBWCICEkADsCoP9YhjIPWr3ziDG7bLHRjarh7TcZeK+KZMfZblTgNLYOsMwluZj
 h+mVUq6Zr8qhkdfBB3iXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver name to be consistent with the name that
is registered as cell name in the MFD driver. Otherwise the driver won't
load.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
---
 drivers/gpio/gpio-kempld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
index 1bdc3a2..d3ed563 100644
--- a/drivers/gpio/gpio-kempld.c
+++ b/drivers/gpio/gpio-kempld.c
@@ -210,7 +210,7 @@ static int kempld_gpio_remove(struct
platform_device *pdev) 
 static struct platform_driver kempld_gpio_driver = {
        .driver = {
-               .name = "gpio-kempld",
+               .name = "kempld-gpio",
                .owner = THIS_MODULE,
        },
        .probe          = kempld_gpio_probe,
