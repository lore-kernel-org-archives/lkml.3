Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaLDKWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:22:05 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:54600 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaLDKWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org
Subject: [PATCH v2 RESEND 00/11] mtd: st_spi_fsm: Align with ST's internal development
Date: Thu,  4 Dec 2014 10:21:41 +0000
Message-Id: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, all,

 [x] Bulid test
 [x] Bisectable
 [x] Smatch
 [x] Sparse

v2:
  These are the last remaining patches in the set, all rebased and
  with the DT documentation requested after the last submission.

v1:
  This patch-set updates ST's FSM SPI-NOR driver with all the internal
  goodness which has happened since the initial (now upstreamed) snapshot
  was taken. It covers just over 6 months worth of internal development
  and bug-fixes. A final whitespace clean-up is also appended to the set
  - to make it look pretty and stuff. :)

Angus Clark (4):
  mtd: st_spi_fsm: Add support for N25Q512 and N25Q00A devices
  mtd: st_spi_fsm: Update the JEDEC probe to handle extended READIDs
  mtd: st_spi_fsm: Update Spansion device entries
  mtd: st_spi_fsm: Improve busy wait handling

Christophe Kerello (1):
  mtd: st_spi_fsm: Provide mask to obtain correct boot device pins

Lee Jones (5):
  mtd: st_spi_fsm: Extend fsm_clear_fifo to handle unwanted bytes
  mtd: st_spi_fsm: Obtain and use EMI clock if provided
  mtd: st_spi_fsm: Fix [-Wsign-compare] build warning
  mtd: st_spi_fsm: Provide documentation for boot device mask property
  mtd: st_spi_fsm: General tidy-up

Nunzio Raciti (1):
  mtd: st_spi_fsm: Add support for Micron N25Q512A

 Documentation/devicetree/bindings/mtd/st-fsm.txt |   4 +
 drivers/mtd/devices/st_spi_fsm.c                 | 687 +++++++++++++++--------
 2 files changed, 470 insertions(+), 221 deletions(-)

-- 
1.9.1

