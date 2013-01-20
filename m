Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3ATDKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 22:10:23 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60416 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3ATDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 22:10:22 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2013 22:10:21 EST
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/2] Fix audio on Nokia RX-51
Date: Sun, 20 Jan 2013 04:04:28 +0100
Message-Id: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series updating rx51 sound driver, using snd_soc_register_card,
adding module alias for autoloading kernel driver and registring sound
driver in rx51 board code.

Pali Rohár (2):
  ASoC: omap: rx51: Use snd_soc_register_card and add module alias for
    autoloading driver
  ARM: OMAP: rx51: Register audio device

 arch/arm/mach-omap2/board-rx51-peripherals.c |   11 ++++++
 sound/soc/omap/rx51.c                        |   50 +++++++++++++++-----------
 2 files changed, 41 insertions(+), 20 deletions(-)

-- 
1.7.10.4

