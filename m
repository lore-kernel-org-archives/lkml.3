Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbaCECDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:03:18 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:35495 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755722AbaCECDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:03:16 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>, <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 0/2] spi: atmel: adopt pinctrl support
Date: Wed, 5 Mar 2014 09:58:48 +0800
Message-ID: <1393984730-14828-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, 

This patch is to adopt pinctrl support to optimize energy usage for the pins
both for the suspend/resume cycle.

The patch is based on the branch: for-next
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git

Best Regards,
Wenyou Yang

Wenyou Yang (2):
  spi: atmel: adopt pinctrl support
  ARM: dts: sama5d36ek: add spi pinctrl sleep state

 arch/arm/boot/dts/sama5d36ek.dts |   14 ++++++++++++++
 drivers/spi/spi-atmel.c          |    9 +++++++++
 2 files changed, 23 insertions(+)

-- 
1.7.9.5

