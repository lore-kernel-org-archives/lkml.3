Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab3EWMAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:00:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62658 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3EWMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:00:39 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <wsa@the-dreams.de>
CC: <guz.fnst@cn.fujitsu.com>, <sonic.zhang@analog.com>,
        <uclinux-dist-devel@blackfin.uclinux.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH RFC v3 0/3] i2c: fix bugs and update API
Date: Thu, 23 May 2013 20:00:01 +0800
Message-ID: <1369310401-31732-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patchset does 3 jobs:
1. fix two bugs in probe
2. convert to devm_* API
3. use module_platform_driver() replace init/exit

v2->v3:
   * convert to devm_* API suggested by Wolfram Sang <wsa@the-dreams.de>
   * use module_platform_driver() replace init/exit 

Libo Chen (3):
  i2c: i2c-bfin-twi: convert to devm_* API
  i2c: pxa: convert to devm_* API
  i2c: pxa: use module_platform_driver() replace init/exit

 drivers/i2c/busses/i2c-bfin-twi.c |   38 +++++--------------
 drivers/i2c/busses/i2c-pxa.c      |   73 ++++++++-----------------------------
 2 files changed, 26 insertions(+), 85 deletions(-)


