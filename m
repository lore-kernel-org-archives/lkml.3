Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaAIKHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:07:07 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46699 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752316AbaAIKG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:06:57 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'walt'" <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Index: AQHPBmhf5d97FnYUxUSD3GhphkgfRJpx0RcAgAFWX4CAAEcRgIAAGCMAgAAj0ICAB/sxgIAAkUsQ
Date: Thu, 9 Jan 2014 10:05:11 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D455F92@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos> <52CDF9CD.8010402@gmail.com>
In-Reply-To: <52CDF9CD.8010402@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s09A7BKs000474

> From: walt
...
> I'm still wondering if I'm suffering from hardware quirks.  From the
> first day I installed my usb3 adapter card and the usb3 disk docking
> station I've noticed some quirky behavior.

Ah - this isn't an 'on chip' usb3 adapter.
Some kind of PCIe card ?

> e.g. I boot the machine with the docking station powered-off, and then
> later I power it on, the usb3 disk is not detected at all -- until I
> reboot the machine with the docking station still powered on.

That will be something completely different to failures when running.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
