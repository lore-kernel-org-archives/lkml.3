Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3IFLEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:04:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48127 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3IFLEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:04:20 -0400
Message-ID: <5229B601.9090109@huawei.com>
Date: Fri, 6 Sep 2013 19:01:21 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Thomas Gleixner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadia Derbey <Nadia.Derbey@bull.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/5] remove unnecessary work pending test
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it. It has been tested in
queue_work_on() already. No functional changed.

Xie XiuQi (5):
  iio: adc: remove unnecessary work pending test
  input: remove unnecessary work pending test
  lib: remove unnecessary work pending test
  staging: olpc_dcon: remove unnecessary work pending test
  ipc: input: remove unnecessary work pending test

 drivers/input/touchscreen/cyttsp4_core.c | 3 +--
 drivers/staging/iio/adc/ad7606_core.c    | 7 +++----
 drivers/staging/olpc_dcon/olpc_dcon.c    | 2 +-
 ipc/util.c                               | 4 +---
 lib/debugobjects.c                       | 2 +-
 5 files changed, 7 insertions(+), 11 deletions(-)

-- 
1.8.2.2


