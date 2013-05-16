Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3EPLwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:52:04 -0400
Received: from abc.logicbricks.com ([89.201.165.132]:2121 "EHLO
	abc.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3EPLvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:51:39 -0400
Content-Class: urn:content-classes:message
Subject: RE: fb driver for logiCVC
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Thu, 16 May 2013 13:51:34 +0200
Message-ID: <ABCPY3ZCHWRJhEG4r3o0000007d@abc.logicbricks.com>
In-Reply-To: <CAMuHMdUW-tVY6=Bu9mabKrkNJsTxJM+Umo6jjcnXpWpzh_5AVw@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fb driver for logiCVC
thread-index: Ac5SJ73g2dfOfjp8Q/6ACAp1S5llaQAA3M2A
References: <9D79B9A9194389468A922F618415D0A401229E7E@abc.xylon.local><20130515184112.251bb949@neptune.home><ABCSCiTtUDvkm6WeI5J00000073@abc.logicbricks.com> <CAMuHMdUW-tVY6=Bu9mabKrkNJsTxJM+Umo6jjcnXpWpzh_5AVw@mail.gmail.com>
From: "Davor Joja" <Davor.Joja@logicbricks.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: =?utf-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        <linux-kernel@vger.kernel.org>,
        "Linux Fbdev development list" <linux-fbdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4GBqA3t021958

Thanks Geert!

Regards,
Davor

-----Original Message-----
From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com] On Behalf Of Geert Uytterhoeven
Sent: Thursday, May 16, 2013 1:23 PM
To: Davor Joja
Cc: Bruno PrÃ©mont; linux-kernel@vger.kernel.org; Linux Fbdev development list
Subject: Re: fb driver for logiCVC

On Thu, May 16, 2013 at 12:35 PM, Davor Joja <Davor.Joja@logicbricks.com> wrote:
> Unfortunately, I have this driver on mentioned git only for few weeks, so there is no usable history.
> Since this is new driver, tested and functional (on kernel 3.8), without git history as stated above, do you have idea how to break it to smaller pieces? I can only think off as one big patch against 3.8.x version.
> That could be accepted for new driver?

A single patch is OK for a new driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
