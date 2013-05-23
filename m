Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab3EWLLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:11:21 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34841 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758424Ab3EWLLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:11:20 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>, <jtzhou@marvell.com>
Subject: [PATCH 0/3] mfd: 88pm800: bug fix and add regulator support
Date: Thu, 23 May 2013 19:10:43 +0800
Message-ID: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

Yi Zhang (3):
  mfd: 88pm800: remove "IRQF_TRIGGER_FALLING" flag
  mfd: 88pm800: fix probe bug
  mfd: 88pm800: add regulator support

 drivers/mfd/88pm800.c       |  139 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/mfd/88pm80x.h |   48 +++++++++++++++
 2 files changed, 178 insertions(+), 9 deletions(-)

