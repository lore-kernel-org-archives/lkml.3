Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3DZMXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:23:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64737 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3DZMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:23:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 1/6] dmaengine: Refactor the DMA40 driver - continued
Date: Fri, 26 Apr 2013 12:38:09 +0100
Message-Id: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a continuation of the first "dmaengine: Refactor the DMA40 driver"
patch-set. It encompasses some recommendations given during the review of
it's predecessor.

 arch/arm/mach-ux500/board-mop500-audio.c    |   12 +++++-----
 arch/arm/mach-ux500/board-mop500-sdi.c      |   16 ++++++-------
 arch/arm/mach-ux500/board-mop500.c          |   22 ++++++++---------
 arch/arm/mach-ux500/usb.c                   |    4 ++--
 drivers/dma/ste_dma40.c                     |   99 +++++++++++++++++++++++++++++++++-------------------------------------------
 drivers/dma/ste_dma40_ll.c                  |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 include/linux/platform_data/dma-ste-dma40.h |   19 ++-------------
 sound/soc/ux500/ux500_pcm.c                 |   10 ++++----
 8 files changed, 147 insertions(+), 157 deletions(-)

