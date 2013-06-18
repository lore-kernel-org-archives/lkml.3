Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab3FRIwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:52:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53575 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3FRIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:52:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 0/3] ARM: ux500: mop500_snowball_ethernet_clock_enable() removal
Date: Tue, 18 Jun 2013 09:51:56 +0100
Message-Id: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

As requested by you, this gets rid of  mop500_snowball_ethernet_clock_enable()
which is no longer in use. It also straightens out a bug which ensures the
SMSC911x's regulator is turned on at start-up when using Device Tree.

This is based on your test-merge-20130615 branch.

Kind regards,
Lee

 arch/arm/boot/dts/dbx5x0.dtsi      |  5 +++++
 arch/arm/boot/dts/snowball.dts     | 13 +++++++------
 arch/arm/mach-ux500/board-mop500.c | 11 -----------
 arch/arm/mach-ux500/board-mop500.h |  1 -
 arch/arm/mach-ux500/cpu-db8500.c   |  1 -
 5 files changed, 12 insertions(+), 19 deletions(-)


