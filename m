Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3LQCe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:34:58 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:46025 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3LQCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:34:57 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBH2Yjdx001078, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v3 0/2] mfd: rtsx: decrease driver size and add new device
Date: Tue, 17 Dec 2013 10:36:57 +0800
Message-ID: <cover.1387246693.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

With the recent added support request of yet another device, the
burden of duplicated code was becoming a little messy. To rectify is,
we init rtl8411-like chips to 8411 param first, then modify the
different values according each chip. And rtl8402 is supported from
this patch.

Micky Ching (2):
  mfd: rtsx: reduce code duplication in rtl8411
  mfd: rtsx: add card reader rtl8402

 drivers/mfd/rtl8411.c  |   89 ++++++++++++++++++------------------------------
 drivers/mfd/rtsx_pcr.c |    5 +++
 drivers/mfd/rtsx_pcr.h |    9 +++++
 3 files changed, 48 insertions(+), 55 deletions(-)

--
1.7.9.5
