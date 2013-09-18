Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3IRN5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:57:35 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50526 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3IRN5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130918133025.GB2953@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309172128.42514@pali> <20130918014942.GD19817@radagast>
 <201309181020.15245@pali> <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
 <20130918133025.GB2953@amd.pavel.ucw.cz>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 18 Sep 2013 15:57:13 +0200
Message-ID: <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, freemangordon@abv.bg,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 3:30 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > So will you do that? Or it is needed to resend this one line
>> >> > hunk again in new email again?
>> >>
>> >> new patch, new email
>> >
>> > Guys, WHY ARE YOU SO STUPID AND ARROGANT?
>> >
>> > Sorry but, need to copy full isolated patch/hunk from one mail to
>> > another is hassling. So what you want from me? Do all those non
>> > sense working only because yesterday you had bad day? Or what?
> ...
>>
>> Hi Pali,
>>
>> There is no need to be rude.
>>
>> Felipe asked you to do the split since he believes that the notifier
>> chain call for musb xceiv and the twl->phy notifier head init should
>> be done in two separate patches.
>
> Actually, there is need to be rude, because Felipe fails to act as
> maintainer. Instead of fixing bugs in his code, he bounces bugfix
> patches, points people to random READMEs and wastes everyones time.
>                                                                         Pavel
>

I don't know what are you talking about (if that happened in another
thread then I need more context). Felipe is not bouncing any bugfix
but just asked to split the patch in two since the patch was solving
two separate issues so is way better to have it in two separate
patches for the reasons I explained before.

So, as far as I can tell Felipe did exactly what I would expect from a
maintainer. He took the time to review the patches sent to him and
gave feedback. If the sender doesn't want to take his feedback into
account and prefer to send pretty insulting emails instead that is his
choice but I would say that is this not the greatest approach to get
your code merged (to say the least).

Best regards,
Javier
