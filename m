Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaAGNxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:53:48 -0500
Received: from mx0.aculab.com ([213.249.233.131]:42217 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750904AbaAGNxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:53:37 -0500
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
Thread-Index: AQHPBmhf5d97FnYUxUSD3GhphkgfRJpx0RcAgAFWX4CAAEcRgIAAGCMAgAAj0ICABMhzgIAA2VQAgAAB+/A=
Date: Tue, 7 Jan 2014 13:51:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D453DD4@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos> <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
In-Reply-To: <52CC014C.5060604@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s07DrptQ018459

> From: walt
...
> Thanks Sarah.  dmesg0 is from the diagnostic patch only.  dmesg1 has all
> three patches applied.  Some of the messages in dmesg1 fell off the end of
> the kernel buffer, so I may need to make the buffer larger next time but
> I'll need a reminder of how to do it.
> 
> As you suspected, the patches didn't fix the problem, sorry.

I think Sarah will want the traces of the transfer being setup (ie just
before the error). Some 'normal' completing transfers are also useful.

You might also find the full trace output in one of the files in /var/log.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
