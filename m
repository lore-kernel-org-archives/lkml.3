Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3HaGpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:45:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34180 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3HaGpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:45:41 -0400
Message-ID: <522190DF.80506@huawei.com>
Date: Sat, 31 Aug 2013 14:44:47 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dmitry.torokhov@gmail.com>
CC: <peter.ujfalusi@ti.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>, <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 0/3] driver: input: fix missing of_node_put
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


decrease np device_node refcount after task completion

Libo Chen (3):
  driver: input: 88pm860x-ts: fix missing of_node_put
  driver: input: twl4030-vibra: fix missing of_node_put
  driver: input: twl6040-vibra: fix missing of_node_put

 drivers/input/misc/twl4030-vibra.c      |    4 +++-
 drivers/input/misc/twl6040-vibra.c      |    3 +++
 drivers/input/touchscreen/88pm860x-ts.c |   22 +++++++++++++++-------
 3 files changed, 21 insertions(+), 8 deletions(-)

