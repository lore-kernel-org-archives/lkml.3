Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaCEQ6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:58:04 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50505 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbaCEQ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:58:02 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/3] iio: adc: at91 fixes
Date: Wed,  5 Mar 2014 17:57:52 +0100
Message-Id: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a kernel crash at probe time when using the at91_adc driver
through platform_data. This crash appeared in 3.13.

The first patch fixes the crash. While it is already quite late, I think it
would be good to get it in 3.14.

The next patches restore support for at91_adc on the at91sam9g45 and at91sam9260
based boards. It would be great if they could make it in 3.14. But I'm not sure
it is worth applying them to 3.13.

Alexandre Belloni (3):
  iio: adc: at91_adc: Repair broken platform_data support
  ARM: at91: at91sam9g45: change at91_adc name
  ARM: at91: at91sam9260: change at91_adc name

 arch/arm/mach-at91/at91sam9260_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |  2 +-
 drivers/iio/adc/at91_adc.c               | 26 ++++++++++++++++++++++----
 3 files changed, 24 insertions(+), 6 deletions(-)

-- 
1.8.3.2

