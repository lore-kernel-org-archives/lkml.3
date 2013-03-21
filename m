Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3CULkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:40:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7643 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3CULkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:40:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <fabio.porcedda@gmail.com>, <laurent.navet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 0/7] pcmcia: at91_cf: clean up and add DT support
Date: Thu, 21 Mar 2013 12:40:10 +0100
Message-ID: <cover.1363865228.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches clean up at91_cf a bit and add DT bindings.
It is based on a previous series from Joachim Eastwood and other cleanup
patches by Fabio and Laurent.
I have collected them together as they are lying around for some time.

Please tell me if It can go through PCMCIA tree or if Andrew or Greg can
take them.
Note that they are not bug fixes, so you can stack them for 3.10.

Thanks for your help, best regards.

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
1.8.0

