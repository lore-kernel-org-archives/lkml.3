Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbaCRXQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:16:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39344 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757255AbaCRXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:16:38 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/3] ARM: at91: improve at91sam9m10g45ek support
Date: Wed, 19 Mar 2014 00:15:38 +0100
Message-Id: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few DT improvements for the at91sam9m10g45ek.

The first patch corrects the ADC support for the at91sam9g45.

The second patch adds ADC and touchscreen support to the at91sam9m10g45ek.

The last one corrects the PWM polarity after the polarity got right in the
driver, following patch "PWM: atmel-pwm: Fix polarity handling"


Alexandre Belloni (3):
  ARM: at91/dt: sam9g45: improve ADC/touchscreen support
  ARM: at91/dt: at91sam9m10g45ek: add ADC and touchscreen support
  ARM: at91/dt: at91sam9m10g45ek PWM leds polarity is inversed

 arch/arm/boot/dts/at91sam9g45.dtsi     | 33 +++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9m10g45ek.dts | 20 ++++++++++++++++++--
 2 files changed, 49 insertions(+), 4 deletions(-)

-- 
1.8.3.2

