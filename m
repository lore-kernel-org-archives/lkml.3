Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255AbaEQRnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:43:55 -0400
Received: from www17.your-server.de ([213.133.104.17]:59588 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842AbaEQRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:43:54 -0400
Date: Sat, 17 May 2014 19:43:42 +0200
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
From: Thomas Meyer <thomas@m3y3r.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        " intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <E1WlieE-0007VZ-Fr@www17.your-server.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4HHi8Bg028501

3.15-rc2 seems to be good, 3.15-rc5 seems to be bad. Bisecting this the next days.

Am 12.05.2014 18:54 schrieb Daniel Vetter <daniel@ffwll.ch>:
>
> On Mon, May 12, 2014 at 10:09:54AM +0300, Jani Nikula wrote: 
> > On Sun, 11 May 2014, Daniel Vetter <daniel.vetter@ffwll.ch> wrote: 
> > > On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote: 
> > >> On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote: 
> > >>> Hi, 
> > >>> 
> > >>> 3.14.3 works as expected. 
> > >>> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server 
> > >>> seems to be disfunctional. 
> > >>> 
> > >>> I see this WARNING in the kernel log before suspend to ram in the early 
> > >>> boot process: 
> > > 
> > > Doesn't ring a bell really. 
> > > - Is there anything in dmesg after resume? 
> > > - How exactly does X misbehave? Is fbcon still working? Does X 
> > > behaviour get restored if you restart X? 
> > > - Can you please try to bisect this issue? Note that the backlight 
> > > issue might be unrelated to the issues with X misbehaving after 
> > > resume. You might need to do a bisect for both if the symptoms don't 
> > > agree. 
> > 
> > I agree the WARNING from i965_enable_backlight() is unrelated. Focus on 
> > the other symptoms first. 
>
> The backlight backtrace seems to be a genuine new bug. Bisecting it would 
> be highly appreciated. Bisecting on the other issue and appending the 
> result to the bug Chris quoated should also really be useful - atm we 
> don't have any reported who can reproduce this clearly enough to do a 
> bisect. 
> -Daniel 
> -- 
> Daniel Vetter 
> Software Engineer, Intel Corporation 
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
