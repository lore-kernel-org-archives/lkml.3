Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaHSUfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:35:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:60778 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaHSUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:35:22 -0400
Date: Tue, 19 Aug 2014 22:35:15 +0200
Subject: Re: [UML] 3.16 build without optimization fails
From: Thomas Meyer <thomas@m3y3r.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: linux@thorsten-knabe.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <E1XJq7k-0002hd-8o@www17.your-server.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7JKZS0L025496

Yes, it's still there.

Am 19.08.2014 22:26 schrieb Richard Weinberger <richard.weinberger@gmail.com>:
>
> On Tue, Aug 19, 2014 at 10:19 PM, Thomas Meyer <thomas@m3y3r.de> wrote: 
> > Hi. 
> > 
> > Thanks for your answer. 
> > 
> > There goes my plan to better understand an UML kernel lock up by using a debugger... Everything gets optimised out with -O2 :-( 
>
> Is it the filesystem/block lockup you saw some time ago? 
> Maybe Thorsten can give more details. 
> He sent me an patch off list a few days ago. 
>
> > Can you give an example function that relies on this GCC feature? 
> > 
> > With kind regards 
> > Thomas 
> > 
> > Am 19.08.2014 22:06 schrieb Valdis.Kletnieks@vt.edu: 
> >> 
> >> On Tue, 19 Aug 2014 21:12:10 +0200, Thomas Meyer said: 
> >> > > Hi, 
> >> > > 
> >> > > the build with -O0 fails with: 
> >> 
> >> > > bug or feature? 
> >> > > 
> >> > > any ideas? 
> >> 
> >> Feature.Â  The kernel is *known* to not build with -O0, because that 
> >> disables *all* function inlining, and there's several functions that *have* 
> >> to be inlined in order to function properly (most notably, anything 
> >> that uses the gcc __builtin_return_address in a function that is expected 
> >> to be inlined). 
>
>
>
> -- 
> Thanks, 
> //richard 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
