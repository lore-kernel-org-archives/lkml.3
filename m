Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3H0IMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:12:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55955 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3H0ILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:11:06 -0400
Message-ID: <521C5EE3.8080605@huawei.com>
Date: Tue, 27 Aug 2013 16:10:11 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, USB <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        <stern@rowland.harvard.edu>
Subject: [PATCH 0/4] usb: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Libo Chen (4):
  usb: fotg210-udc: use platform_{get,set}_drvdata()
  usb: r8a66597-hcd: use platform_{get,set}_drvdata()
  usb: phy-tegra-usb: use platform_{get,set}_drvdata()
  usb: renesas_usbhs: use platform_{get,set}_drvdata()

 drivers/usb/gadget/fotg210-udc.c   |    4 ++--
 drivers/usb/host/r8a66597-hcd.c    |    4 ++--
 drivers/usb/phy/phy-tegra-usb.c    |    2 +-
 drivers/usb/renesas_usbhs/common.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

