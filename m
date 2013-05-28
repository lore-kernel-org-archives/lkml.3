Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3E1Etc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:49:32 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:42972 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab3E1Etb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:49:31 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <cxie4@marvell.com>, <jtzhou@marvell.com>,
        <yizhang@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] mfd: 88pm800: bug fix and regulator support
Date: Tue, 28 May 2013 12:48:57 +0800
Message-ID: <1369716541-20034-1-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

v2: fix an "&&" usage error of "mfd: 88pm800: fix probe bug" in v1

Yi Zhang (4):
  mfd: 88pm800: fix NULL pointer error
  mfd: 88pm800: remove "IRQF_TRIGGER_FALLING" flag
  mfd: 88pm800: fix probe bug
  mfd: 88pm800: add regulator support

 drivers/mfd/88pm800.c       |  147 +++++++++++++++++++++++++++++++++++++++----
 include/linux/mfd/88pm80x.h |   48 ++++++++++++++
 2 files changed, 182 insertions(+), 13 deletions(-)

-- 
1.7.4.1

