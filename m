Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3EGBWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:22:34 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:45109 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab3EGBWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:22:33 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <xiechao.mail@gmail.com>,
        <linux@arm.linux.org.uk>, <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead>, <robert.jarzmik@free.fr>,
        <akpm@linux-foundation.org>, <liangs@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 0/2] rtc: pxa: add pxa95x rtc support
Date: Mon, 6 May 2013 21:17:25 -0400
Message-ID: <1367889447-15619-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series remove the incorrect patch, and submit the correct one.

Chao Xie (2):
  Revert "drivers/rtc/rtc-pxa.c: fix set time sync time issue"
  rtc: pxa: add pxa95x rtc support

 drivers/rtc/rtc-pxa.c   |  141 +++++++++++++++++++++++++++--------------------
 include/linux/rtc-pxa.h |   18 ------
 2 files changed, 82 insertions(+), 77 deletions(-)
 delete mode 100644 include/linux/rtc-pxa.h

-- 
1.7.4.1

