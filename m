Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaEAJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40609 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaEAJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com
Subject: [PATCH 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Date: Thu,  1 May 2014 10:56:07 +0100
Message-Id: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD Folks,

This driver is now at v1.  Suggestions from the RFC patch-set have now
been applied.  None of the framework internals are now exported for use
within the driver, as it now uses the 'ecc' call-backs provided.
Hopefully the driver now conforms to what's expected and will be suitable
to be merged.

NB: This driver is based on a patch written, but not yet submitted by
Brian Norris which renames .erase_cmd() to .erase() and places
responsibility of .waitfunc() functionality into those call-backs.

Kind regards,
Lee

 Documentation/devicetree/bindings/mtd/stm-nand.txt |  123 +
 arch/arm/boot/dts/stih41x-b2020.dtsi               |   39 +
 drivers/mtd/nand/Kconfig                           |   14 +
 drivers/mtd/nand/Makefile                          |    2 +
 drivers/mtd/nand/stm_nand_bch.c                    | 2437 ++++++++++++++++++++
 drivers/mtd/nand/stm_nand_dt.c                     |  149 ++
 drivers/mtd/nand/stm_nand_dt.h                     |   39 +
 drivers/mtd/nand/stm_nand_regs.h                   |  332 +++
 include/linux/mtd/stm_nand.h                       |  104 +
 9 files changed, 3239 insertions(+)

