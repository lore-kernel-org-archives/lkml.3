Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3JNFlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:41:17 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:57522 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3JNFlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:41:02 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 0/5] ARM:at91:enable sound on at91sam9n12ek board
Date: Mon, 14 Oct 2013 13:38:28 +0800
Message-Id: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enable sound on at91sam9n12ek board with wm8904 codec


Bo Shen (5):
  ARM: at91: add at91sam9n12 ssc clock in look up table
  ARM: at91: add ssc dma parameter for at91sam9n12
  ARM: at91: enable wm8904 on at91sam9n12ek board
  ARM: at91: enable ssc on at91sam9n12ek board
  ARM: at91: add sound support on at91sam9n12ek board

 arch/arm/boot/dts/at91sam9n12.dtsi  |    3 +++
 arch/arm/boot/dts/at91sam9n12ek.dts |   34 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9n12.c    |    1 +
 3 files changed, 38 insertions(+)

-- 
1.7.9.5

