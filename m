Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAJO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:59:59 -0500
Received: from mx0.aculab.com ([213.249.233.131]:43135 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750944AbaAJO7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:59:54 -0500
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
Thread-Index: AQHPDZWc5d97FnYUxUSD3GhphkgfRJp+CKKAgAAD//A=
Date: Fri, 10 Jan 2014 14:58:03 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D457C16@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D0065B.4060905@gmail.com>
In-Reply-To: <52D0065B.4060905@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0AF06vE009813

From: walt
> > In the meantime, try this patch, which is something of a long shot.
> 
> No difference.  But I notice the code enables the TRB quirk only if the
> xhci_version is specifically 0x95.  My debug messages claim that "xHCI
> doesn't need link TRB QUIRK" so I'm wondering if adding my asmedia device
> to the quirks list really doesn't change anything unless it's xhci 0.95.

I think the intention was that the quirk would be applied for your
hardware even though it claims to be version 0.96.
That was gust a hopeful guess that the same change would help.

> Does lspci provide that information?  I'm not seeing anything obvious.
I've only seen it in the diagnostic prints (that aren't normally output).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
