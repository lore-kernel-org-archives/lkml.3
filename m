Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3FFIY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:24:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:56959 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3FFIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:24:24 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        <manabian@gmail.com>, <fabio.porcedda@gmail.com>,
        <laurent.navet@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 0/7] pcmcia: at91_cf: clean up and add DT support
Date: Thu, 6 Jun 2013 10:24:13 +0200
Message-ID: <cover.1370506678.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches clean up at91_cf a bit and add DT bindings.
They are based on a previous series from Joachim Eastwood and other cleanup
patches by Fabio and Laurent.
I have collected them together as they are lying around for some time.

Greg kindly told me that he can take them through his char/misc driver
tree, so I resend the series.

Thanks for your help, best regards.

v3: rebased on top of 3.10-rc4

v2: add 2 more cleanup patches:
	- move to module_platform_driver_probe()
	- little trivial indentation fix

Fabio Porcedda (1):
  pcmcia: at91_cf: use module_platform_driver_probe()

Joachim Eastwood (5):
  pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
  pcmcia: at91_cf: convert to dev_ print functions
  pcmcia: at91_cf: use devm_ functions for allocations
  pcmcia: at91_cf: clean up header includes
  pcmcia: at91_cf: add support for DT

Laurent Navet (1):
  pcmcia/trivial: at91_cf: fix checkpatch error

 .../devicetree/bindings/ata/atmel-at91_cf.txt      |  19 +++
 drivers/pcmcia/Kconfig                             |   2 +-
 drivers/pcmcia/at91_cf.c                           | 176 ++++++++++-----------
 3 files changed, 108 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/atmel-at91_cf.txt

-- 
1.8.2.2

