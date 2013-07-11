Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3GKDeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:34:03 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28079 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3GKDeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:34:00 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 0/3] arm: atmel: at91sam9n12: add i2c pinctrl and qt1070 support
Date: Thu, 11 Jul 2013 11:30:43 +0800
Message-Id: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is based on linux master branch, implementation as following:
  - add the i2c pinctrl which needed for using at91sam9n12 TWI
  - enable qt1070
  - trival fix for the gpio-key pin number

Changes in v2:
  - remove comments as use micro
  - using micro for interrupt trigger mode

Bo Shen (3):
  arm: atmel: at91sam9n12: add pinctrl of TWI
  arm: atmel: at91sam9n12: add qt1070 support
  arm: atmel: at91sam9n12: correct pin number of gpio-key

 arch/arm/boot/dts/at91sam9n12.dtsi  |   20 ++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts |   18 +++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

-- 
1.7.9.5

