Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3GDHT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:28 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:45146 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3GDHTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:25 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 0/4] arm: atmel: enable kernel uncompress info output
Date: Thu,  4 Jul 2013 15:16:38 +0800
Message-Id: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch set enable kernel uncompress info output
  - sama5d3
  - at91sam9n12

without this patch set, it won't show following information
---8>---
Uncompressing Linux... done, booting the kernel.
---<8---


Bo Shen (4):
  arm: atmel: sama5: add definition for usart base address
  arm: atmel: include sama5d3.h into hardware.h
  arm: atmel: sama5: enable kernel uncompress info output
  arm: atmel: sam9n12: enable kernel uncompress info output

 arch/arm/mach-at91/include/mach/hardware.h   |    1 +
 arch/arm/mach-at91/include/mach/sama5d3.h    |    8 ++++++++
 arch/arm/mach-at91/include/mach/uncompress.h |   13 +++++++++++++
 3 files changed, 22 insertions(+)

-- 
1.7.9.5

