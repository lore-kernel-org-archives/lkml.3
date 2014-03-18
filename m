Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaCRB7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:59:03 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39999 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaCRB6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:58:46 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2I1wG6g029140, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] add new cmd type handle and remove smatch warnings
Date: Tue, 18 Mar 2014 10:01:43 +0800
Message-ID: <cover.1395107222.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add new command type(R1 without CRC) handle, without this patch mmc card
initialize will be failed.

Using a more careful handle in request timeout, and debug info is printed
using non DMA mode. Smatch warning was removed.

Micky Ching (2):
  mmc: rtsx: add R1-no-CRC mmc command type handle
  mmc: rtsx: modify error handle and remove smatch warnings

 drivers/mmc/host/rtsx_pci_sdmmc.c |  121 ++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 54 deletions(-)

--
1.7.9.5
