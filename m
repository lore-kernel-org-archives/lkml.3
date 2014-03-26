Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaCZQjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:39:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52565 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaCZQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:39:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: [PATCH 00/15] mtd: st_spi_fsm: Align with ST's internal development
Date: Wed, 26 Mar 2014 16:39:14 +0000
Message-Id: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, all,

This patch-set updates ST's FSM SPI-NOR driver with all the internal
goodness which has happened since the initial (now upstreamed) snapshot
was taken. It covers just over 6 months worth of internal development
and bug-fixes. A final whitespace clean-up is also appended to the set
- to make it look pretty and stuff. :)

 drivers/mtd/devices/st_spi_fsm.c | 903 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 1 file changed, 579 insertions(+), 324 deletions(-)

