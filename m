Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3EII16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:27:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26225 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3EII14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:27:56 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <Sonic.Zhang@analog.com>, <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH v2 0/2] i2c: fix two wrong mem release
Date: Thu, 9 May 2013 16:27:22 +0800
Message-ID: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix two wrong mem release

* Changelog from v1:
  * exchange out_error_no_irq and out_error_pin_mux  suggested by Sonic <Sonic.Zhang@analog.com>  
  * add some new tag , make code cleanly

Libo Chen (2):
  i2c: i2c-bfin-twi: don`t free peripheral before it init successful
  i2c: pxa: no need release_mem_region before request_mem_region
    successful

 drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c      |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)


