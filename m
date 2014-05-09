Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaEIG6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:58:04 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49364 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaEIG6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:58:02 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/3] ARM: defconfig: drop CONFIG_COMMON_CLK_DEBUG option
Date: Fri,  9 May 2014 12:27:46 +0530
Message-Id: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi All,

This patch series drops the CONFIG_COMMON_CLK_DEBUG option
from rest of the defconfig files.

Changes for v3:
a> Splitted up the patch so that individual owners can pick it up.

Lad, Prabhakar (3):
  ARM: integrator: drop CONFIG_COMMON_CLK_DEBUG
  ARM: sunxi: drop CONFIG_COMMON_CLK_DEBUG
  ARM: vt8500: drop CONFIG_COMMON_CLK_DEBUG

 arch/arm/configs/integrator_defconfig   |    1 -
 arch/arm/configs/sunxi_defconfig        |    1 -
 arch/arm/configs/vt8500_v6_v7_defconfig |    1 -
 3 files changed, 3 deletions(-)

-- 
1.7.9.5

