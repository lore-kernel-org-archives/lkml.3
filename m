Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3ASJwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:52:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54657 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3ASJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:52:22 -0500
From: Liang Li <liang.li@windriver.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <liang.li@windriver.com>, <dvhart@linux.intel.com>,
        <bruce.ashfield@windriver.com>, <tomoya.rohm@gmail.com>,
        <feng.tang@intel.com>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] pch_uart: fix a deadlock and add sysrq support
Date: Sat, 19 Jan 2013 17:52:09 +0800
Message-ID: <1358589131-28187-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1/2 is fixing a deadlock issue caused by serial error when using
pch_uart as serial console. Send brk to serial console can be used to
reproduce the issue.

Patch 2/2 is adding sysrq support for pch_uart.

Diffstat:

 drivers/tty/serial/pch_uart.c |   56 ++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 15 deletions(-)

---

Thanks,
Liang Li

