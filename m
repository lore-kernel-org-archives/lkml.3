Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbaFTQU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:20:29 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:45823
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbaFTQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:20:28 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Ian Abbott <abbotti@mev.co.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: RE: [-next] comedi I/O accessor name clashes
Thread-Topic: [-next] comedi I/O accessor name clashes
Thread-Index: AQHPjHfaqfeYwD+BwUCPw02uo4iYBZt6TXgAgAACKQD//92ssA==
Date: Fri, 20 Jun 2014 16:20:27 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825EB28CA@P3PWEX4MB008.ex4.secureserver.net>
References: <CAMuHMdVhU6JZFzuPkx=wtLcPYc7wwaMFwCrZu=zG7PmCYssy-g@mail.gmail.com>
	<53A41720.9020609@mev.co.uk>
 <CAMuHMdXiwJqCHP0+BPaVn2f2B4eTe957Vun=2ue6FOZk60kPKw@mail.gmail.com>
In-Reply-To: <CAMuHMdXiwJqCHP0+BPaVn2f2B4eTe957Vun=2ue6FOZk60kPKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5KGKYri003156

On Friday, June 20, 2014 4:20 AM, Geert Uytterhoeven wrote:
> On Fri, Jun 20, 2014 at 1:12 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>> drivers/staging/comedi/drivers/ni_atmio.c:318:38: error: macro
>>> "writew" passed 3 arguments, but takes just 2
>
>> Thanks, but Hartley has already fixed it and Greg has applied it to his
>> staging-next branch.  It should wend it's merry way to linux-next in the
>> not-too-distant future.
>
> Thanks, good to hear that!

Geert / Ian,

The patches to fix this are in next-20140620.

Sorry for the trouble,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
