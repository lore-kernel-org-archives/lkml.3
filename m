Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3GAWxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:53:08 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.107]:26288 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736Ab3GAWxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:53:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1372719182!6252951!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] usb: ohci-ep93xx: do a bit of housecleaning
Date: Mon, 1 Jul 2013 15:52:29 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307011552.29868.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy up this driver a bit.

v2: redo patch 4 based on suggestions from Alan Stern

H Hartley Sweeten (4):
  usb: ohci-ep93xx: use devm_ioremap_resource()
  usb: ohci-ep93xx: use platform_get_irq()
  usb: ohci-ep93xx: use devm_clk_get()
  usb: ohci-ep93xx: tidy up driver (*probe) and (*remove)

 drivers/usb/host/ohci-ep93xx.c | 137 ++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 85 deletions(-)

-- 
1.8.1.4

