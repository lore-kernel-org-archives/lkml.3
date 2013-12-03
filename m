Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3LCJYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:24:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33371 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3LCJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:40 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB39OSXa010387, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/3] mfd: rtsx: decrease driver size and add new device
Date: Tue, 3 Dec 2013 17:26:30 +0800
Message-ID: <cover.1386051860.git.micky_ching@realsil.com.cn>
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
different values according each chip.

Micky Ching (3):
  mfd: rtsx: reduce code duplication in rtl8411
  mfd: rtsx: add card reader rtl8402
  mfd: rtsx: prevent 'used uninitialised' warnings

 drivers/mfd/rtl8411.c  |  100 ++++++++++++++++++++++--------------------------
 drivers/mfd/rtsx_pcr.c |    5 +++
 drivers/mfd/rtsx_pcr.h |    9 +++++
 3 files changed, 60 insertions(+), 54 deletions(-)

--
1.7.9.5
