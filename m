Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3HLMbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:31:22 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63719 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3HLMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:31:18 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/4] Add sound in SAM9x5 DTS
Date: Mon, 12 Aug 2013 14:30:58 +0200
Message-Id: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the sam9x5-wm8731 machine driver has been merged, we have now to add
the device tree nodes...
And here they are !

(Based on next-20130812)
Tested on at91sam9g35-ek

[I didn't add the DT list, as far as there's no new binding, we don't
have to bother themi, right ?]

Richard Genoud (4):
  ARM: AT91: DTS: sam9x5: add SSC DMA parameters
  ARM: AT91: DTS: sam9x5ek: add WM8731 codec
  ARM: AT91: DTS: sam9x5ek: enable SSC
  ARM: AT91: DTS: sam9x5ek: add sound configuration

 arch/arm/boot/dts/at91sam9x5.dtsi   |    3 +++
 arch/arm/boot/dts/at91sam9x5ek.dtsi |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

-- 
1.7.10.4

