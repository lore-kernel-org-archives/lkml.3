Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3EIFAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:00:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50148 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3EIFAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:00:44 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 0/4] usb: fix four memleak 
Date: Thu, 9 May 2013 12:58:07 +0800
Message-ID: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix four goto wrong tag, avoid memleak 

Libo Chen (4):
  usb: ehci-s5p: fix memleak when fallback to pdata
  usb: isp1760-if: fix memleak when platform_get_resource fail
  usb: ohci: fix goto wrong tag in err case
  usb: tilegx: fix memleak when create hcd fail

 drivers/usb/host/ehci-s5p.c    |    1 +
 drivers/usb/host/isp1760-if.c  |    4 +++-
 drivers/usb/host/ohci-nxp.c    |   12 ++++++------
 drivers/usb/host/ohci-tilegx.c |    7 +++++--
 4 files changed, 15 insertions(+), 9 deletions(-)


