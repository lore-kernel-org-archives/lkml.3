Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaCTLMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:12:05 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40183 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbaCTLMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:12:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, angus.clark@st.com
Subject: [PATCH 0/5] mtd: st_spi_fsm: Sweep-up remaining blocking-issues
Date: Thu, 20 Mar 2014 11:11:42 +0000
Message-Id: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian,

Sincerest apologies for missing these before.

I hope this now covers all of points you raised.

 drivers/mtd/devices/st_spi_fsm.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)


