Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3K0TIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:08:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58753 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab3K0TIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 00/13] mfd: menelaus: a few cleanups
Date: Wed, 27 Nov 2013 13:06:44 -0600
Message-ID: <1385579217-20127-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

few cleanups on the old menelaus driver. I don't have
HW to test these patches, maybe Aaro can help here ?

cheers

Felipe Balbi (13):
  mfd: menelaus: drop __exit section annotation
  mfd: menelaus: switch over to module_i2c_driver
  mfd: menelaus: convert to threaded irq
  mfd: menelaus: remove unnecessary loop
  mfd: menelaus: use for_each_set_bit()
  mfd: menelaus: pass menelaus pointer as argument to enable/disable irq
  mfd: menelaus: limit the usage of the_menelaus
  mfd: menelaus: pass menelaus_chip pointer to add/remove irq functions
  mfd: menelaus: pass menelaus_chip pointer to get/set voltage
  mfd: menelaus: pass menelaus_chip argument to menelaus <-> time
    helpers
  mfd: menelaus: start to use irqdomain
  mfd: menelaus: switch all children to threaded_irq
  mfd: menelaus: remove unnecessary definition

 drivers/mfd/menelaus.c | 616 +++++++++++++++++++++++++------------------------
 1 file changed, 319 insertions(+), 297 deletions(-)

-- 
1.8.4.GIT

