Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaANJqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:46:07 -0500
Received: from mx0.aculab.com ([213.249.233.131]:39609 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751599AbaANJqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:46:02 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'walt'" <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Index: AQHPELhlWPjDYPI+s0G+DC1zL1oFlJqD+AZQ
Date: Tue, 14 Jan 2014 09:43:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45B08A@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
In-Reply-To: <52D4791B.3030309@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0E9kEfN031586

From: walt
> On 01/09/2014 03:50 PM, Sarah Sharp wrote:
> 
> >>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> >>
> >> I've wondered if my xhci problems might be caused by hardware quirks, and
> >> wondering why I seem to be the only one who has this problem.
> >>
> >> Maybe I could "take one for the team" by buying new hardware toys that I
> >> don't really need but I could use to test the xhci driver?  (I do enjoy
> >> buying new toys, necessary, or, um, maybe not :)
> >
> > It would be appreciated if you could see if your device causes other
> > host controllers to fail.  Who am I to keep a geek from new toys? ;)
> 
> Sarah, I just fixed my xhci bug for US$19.99 :)
> 
> #lspci | tail -1
> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)

Do you know which version of the xhci spec it conforms to?
(Will probably be 0.96 or 1.00).

Of course, ASMedia will probably change the silicon they are using without
changing anything on the packaging.

	David
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
