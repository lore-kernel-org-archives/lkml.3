Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3C1QLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:11:54 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45620 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3C1QLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:11:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 00/33] Regulators: Bring the AB8500 into the 21st century
Date: Thu, 28 Mar 2013 16:11:00 +0000
Message-Id: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Here is what's left.

I've also split out the "Low Power Battery" patch and squashed a few
of the ab8500-ext fixups back into the original commit as requested. 

Kind regards,
Lee

 arch/arm/mach-ux500/board-mop500-regulators.c |  682 +++++++++++++++++++++++++-
 arch/arm/mach-ux500/board-mop500-regulators.h |    3 +
 arch/arm/mach-ux500/board-mop500.c            |    5 +-
 drivers/regulator/Makefile                    |    2 +-
 drivers/regulator/ab8500-ext.c                |  470 ++++++++++++++++++
 drivers/regulator/ab8500.c                    | 2660 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/mfd/abx500/ab8500.h             |   11 +-
 include/linux/regulator/ab8500.h              |  210 +++++++-
 8 files changed, 3800 insertions(+), 243 deletions(-

