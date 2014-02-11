Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaBKTob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:44:31 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39367 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752854AbaBKToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:44:24 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/3] arm: at91: update defconfigs
Date: Tue, 11 Feb 2014 20:43:58 +0100
Message-Id: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few at91 defconfigs where not updated in a long time, refresh the configs for
at91sam9rl and at91sam9260/at91sam9g20.

Alexandre Belloni (3):
  arm: at91sam9rl: refresh defconfig
  arm: at91sam9260_9g20: remove useless configuration
  arm: at91sam9260_9g20: refresh configuration

 arch/arm/configs/at91sam9260_9g20_defconfig |  9 ++-------
 arch/arm/configs/at91sam9rl_defconfig       | 10 +++++++---
 2 files changed, 9 insertions(+), 10 deletions(-)

-- 
1.8.3.2

