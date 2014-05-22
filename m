Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaEVLYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:24:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36064 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaEVLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:24:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Subject: [PATCH v2 00/10] mtd: st_spi_fsm: Align with ST's internal development
Date: Thu, 22 May 2014 12:23:58 +0100
Message-Id: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, all,

v2:
  These are the last remaining patches in the set, all rebased and
  with the DT documentation requested after the last submission.

v1:
  This patch-set updates ST's FSM SPI-NOR driver with all the internal
  goodness which has happened since the initial (now upstreamed) snapshot
  was taken. It covers just over 6 months worth of internal development
  and bug-fixes. A final whitespace clean-up is also appended to the set
  - to make it look pretty and stuff. :)

 Documentation/devicetree/bindings/mtd/st-fsm.txt |   2 +
 drivers/mtd/devices/st_spi_fsm.c                 | 687 +++++++++++++++--------
 2 files changed, 469 insertions(+), 220 deletions(-)


