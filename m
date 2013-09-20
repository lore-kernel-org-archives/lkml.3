Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3ITTYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:24:52 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:34933 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3ITTYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:24:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] drivers: bluetooth: btusb: Added support for Belkin F8065bf usb bluetooth device
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1379704619-27691-1-git-send-email-kernel@kenobrien.org>
Date: Fri, 20 Sep 2013 14:24:43 -0500
Cc: gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E19250BC-3E1A-4DC9-8612-190829CF68EA@holtmann.org>
References: <1379704619-27691-1-git-send-email-kernel@kenobrien.org>
To: "Ken O'Brien" <kernel@kenobrien.org>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

> Belkin bluetooth device's usb device id added to generic usb bluetooth driver.
> 
> It's another instance of Broadcom's BCM20702A0.
> 
> Relevant section from /sys/kernel/debug/usb/devices:
> 
> T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=050d ProdID=065a Rev= 1.12
> S:  Manufacturer=Broadcom Corp
> S:  Product=BCM20702A0
> S:  SerialNumber=0002723E2D29
> C:* #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

we might consider a generic rule for this:

	/* comment of the device vendor and type goes here */
        { USB_VENDOR_AND_INTERFACE_INFO(0x050d, 0xff, 0x01, 0x01) },

Regards

Marcel

