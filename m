Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3ETBGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:06:48 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:54792 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754908Ab3ETBGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:06:47 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <nicolas.ferre@atmel.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH] Change internal SRAM memory type to "MT_MEMORY_SO"
Date: Mon, 20 May 2013 09:05:10 +0800
Message-ID: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

This patch is to change the internal SRAM memory type to "MT_MEMORY_SO", the right type.

It tested on sama5d3xek boards.

It based on v3.10-rc1.

Best Regards,
Wenyou Yang

Wenyou Yang (1):
  ARM: at91: Fix: Change internal SRAM memory type to "MT_MEMORY_SO"

 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.9.5

