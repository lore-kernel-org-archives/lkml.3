Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3EPL1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:27:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57454 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3EPL1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:27:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/6] crypto: ux500/[cryp|hash] - Enable Device Tree
Date: Thu, 16 May 2013 12:27:20 +0100
Message-Id: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set simply allows ux500-[cryp|hash] drivers to be probed
when Snowball is running with Device Tree enabled.

Linus,

Feel free to split the DTS changes out into your ux500-devicetree branch.

 arch/arm/boot/dts/dbx5x0.dtsi         |   17 +++++++++++++++++
 arch/arm/boot/dts/snowball.dts        |    8 ++++++++
 arch/arm/mach-ux500/cpu-db8500.c      |    2 ++
 drivers/crypto/ux500/cryp/cryp_core.c |    6 ++++++
 drivers/crypto/ux500/hash/hash_core.c |    6 ++++++
 5 files changed, 39 insertions(+)

