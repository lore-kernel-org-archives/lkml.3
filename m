Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3GJJya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:54:30 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:33593 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3GJJy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:54:29 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 0/3] arm: atmel: at91sam9n12: add i2c pinctrl and qt1070 support
Date: Wed, 10 Jul 2013 17:51:06 +0800
Message-Id: <1373449869-5083-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is based on linux master branch, implementation as following:
  - add the i2c pinctrl which needed for using at91sam9n12 TWI
  - enable qt1070
  - trivial fix for the gpio-key pin number


Bo Shen (3):
  arm: atmel: at91sam9n12: add pinctrl of TWI
  arm: atmel: at91sam9n12: add qt1070 support
  arm: atmel: at91sam9n12: correct pin number of gpio-key

 arch/arm/boot/dts/at91sam9n12.dtsi  |   20 ++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts |   18 +++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

-- 
1.7.9.5

