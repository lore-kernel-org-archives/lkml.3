Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3LRCBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:01:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58328 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LRCBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:01:17 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBI216Bm004446, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 0/2] mfd: rtsx: decrease driver size and add new device
Date: Wed, 18 Dec 2013 10:03:11 +0800
Message-ID: <cover.1387331869.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

we add a macro to simplify setting pull control, and use a common init
function to init the common params for 8411-like chips. at last we add
support for rtl8402 chip.

Micky Ching (2):
  mfd: rtsx: add set pull control macro and simplify rtl8411
  mfd: rtsx: add support for card reader rtl8402

 drivers/mfd/rtl8411.c  |   95 ++++++++++++++++++++++++++----------------------
 drivers/mfd/rtsx_pcr.c |    5 +++
 drivers/mfd/rtsx_pcr.h |    9 +++++
 3 files changed, 66 insertions(+), 43 deletions(-)

--
1.7.9.5
