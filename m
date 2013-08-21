Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3HUKPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:15:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22328 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3HUKPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:15:19 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>
CC: <davem@davemloft.net>, <linux-can@vger.kernel.org>, <lizefan@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <libo.chen@huawei.com>
Subject: [PATCH 0/2] net: can: use platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:14:59 +0800
Message-ID: <1377080099-14552-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_set_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Libo Chen (2):
  net: can: at91_can: use platform_set_drvdata()
  net: can: flexcan: use platform_set_drvdata()

 drivers/net/can/at91_can.c |    2 +-
 drivers/net/can/flexcan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


