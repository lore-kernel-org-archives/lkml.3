Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3F2A2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:28:13 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:60948 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893Ab3F2A2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:28:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1372465688!11562094!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] usb: ohci-ep93xx: do a bit of house cleaning
Date: Fri, 28 Jun 2013 17:26:49 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281726.49367.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy up this driver a bit.

H Hartley Sweeten (4):
  usb: ohci-ep93xx: use devm_ioremap_resource()
  usb: ohci-ep93xx: use platform_get_irq()
  usb: ohci-ep93xx: use devm_clk_get()
  usb: ohci-ep93xx: tidy up ohci_hcd_ep93xx_drv_probe()

 drivers/usb/host/ohci-ep93xx.c | 60 ++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

-- 
1.8.1.4

