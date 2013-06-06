Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab3FFLWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30700 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3FFLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:51 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 0/7] irq: fix checkpatch errors and warnings 
Date: Thu, 6 Jun 2013 19:20:24 +0800
Message-ID: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all the checkpath errors in kernel/irq dir, and some warnings
also fixed.

Kefeng Wang (7):
  irq: fix checkpatch warnings
  irq: fix checkpatch error
  irq: fix checkpatch error
  irq: fix all checkpatch errors and warnings
  irq: fix all checkpatch errors and warnings
  irq: fix checkpatch warnings
  irq: fix all checkpatch errors and warnings

 kernel/irq/chip.c      |  6 ++++--
 kernel/irq/handle.c    |  7 ++++---
 kernel/irq/irqdesc.c   | 15 ++++++++++-----
 kernel/irq/irqdomain.c |  6 +++---
 kernel/irq/manage.c    | 31 +++++++++++++++++++------------
 kernel/irq/proc.c      | 11 ++++++-----
 kernel/irq/spurious.c  | 33 ++++++++++++++++-----------------
 7 files changed, 62 insertions(+), 47 deletions(-)

-- 
1.8.2.1


