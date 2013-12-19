Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3LSOoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:44:13 -0500
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:40196 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3LSOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:44:11 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH] gpio: add GPIO hogging mechanism
Date: Thu, 19 Dec 2013 15:34:30 +0100
Message-Id: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 292452500827175010
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This a proposal for the GPIO hog concept described by Linus (Walleij).

I know there were work in progress on this subject (Jiri and Ben at least:
https://www.mail-archive.com/linux-gpio@vger.kernel.org/msg00864.html),
so don't hesitate to point out if something similar has already been posted.

Best Regards,

Boris 

Boris BREZILLON (1):
  gpio: add GPIO hogging mechanism

 Documentation/devicetree/bindings/gpio/gpio.txt |   47 ++++++++
 drivers/base/Makefile                           |    1 +
 drivers/base/dd.c                               |    5 +
 drivers/base/gpio.c                             |   59 ++++++++++
 drivers/gpio/devres.c                           |   39 +++++++
 drivers/gpio/gpiolib-of.c                       |  134 +++++++++++++++++++++++
 drivers/gpio/gpiolib.c                          |  103 +++++++++++++++++
 include/linux/device.h                          |    5 +
 include/linux/gpio/consumer.h                   |   25 +++++
 include/linux/gpio/devinfo.h                    |   38 +++++++
 include/linux/of_gpio.h                         |   19 ++++
 11 files changed, 475 insertions(+)
 create mode 100644 drivers/base/gpio.c
 create mode 100644 include/linux/gpio/devinfo.h

-- 
1.7.9.5

