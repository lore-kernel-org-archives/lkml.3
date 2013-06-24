Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3FXKfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:35:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49118 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3FXKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:35:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Josh Wu <josh.wu@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
Date: Mon, 24 Jun 2013 12:35:15 +0200
Message-ID: <cover.1372069834.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little series is for enabling the support of SPI on at91sam9n12 and
sama5d3 families.

Nicolas Ferre (3):
  ARM: at91/DT: fix SPI compatibility string
  ARM: at91/DT: sama5d3: add SPI DMA client infos
  ARM: at91/DT: at91sam9n12: add SPI DMA client infos

 arch/arm/boot/dts/at91sam9n12.dtsi |  6 ++++++
 arch/arm/boot/dts/sama5d3.dtsi     | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
1.8.2.2

