Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3EBKuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:50:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40055 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3EBKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:50:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/8] crypto: Fix clocks and DMA configuration
Date: Thu,  2 May 2013 11:49:42 +0100
Message-Id: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set ensures any clocks that are obtained by the ux500
crypto drivers are prepared for use. We also request DMA channels and
configure them in the correct way using the new dmaengine API.

 arch/arm/mach-ux500/board-mop500.c    |   14 ++------------
 drivers/crypto/ux500/cryp/cryp.h      |    7 ++++++-
 drivers/crypto/ux500/cryp/cryp_core.c |   31 ++++++++++++++++++++++++++++++-
 drivers/crypto/ux500/hash/hash_alg.h  |    5 ++++-
 drivers/crypto/ux500/hash/hash_core.c |   24 ++++++++++++++++++++++--
 5 files changed, 64 insertions(+), 17 deletions(-)

