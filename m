Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaDFJn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:43:59 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:42303 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaDFJny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:43:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140328071743.GA17588@kroah.com>
References: <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net> <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr> <20130713093552.GU8252@type>
 <20130715091230.GA8786@amd.pavel.ucw.cz> <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
 <20140316101946.GJ6436@type.youpi.perso.aquilenet.fr> <CAHYPw2EAgjdcNATy0d6DhbT9qHAHJLda7gsLrnSJ7F4Cj=a-JQ@mail.gmail.com>
 <20140328070136.GA15953@amd.pavel.ucw.cz> <20140328071743.GA17588@kroah.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Sun, 6 Apr 2014 11:43:13 +0200
Message-ID: <CAHYPw2FAVtxxt_6=LArC=T_Ca=+tTsE37U29mrY-=OViHXf_2g@mail.gmail.com>
Subject: Re: 8 months to review a patch (was Re: [PATCH] Route kbd LEDs
 through the generic LEDs layer)
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, dtor@mail.ru,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-28 8:17 GMT+01:00 Greg KH <greg@kroah.com>:
> On Fri, Mar 28, 2014 at 08:01:36AM +0100, Pavel Machek wrote:
>> On Thu 2014-03-27 02:08:17, Pali Rohár wrote:
>> > 2014-03-16 11:19 GMT+01:00 Samuel Thibault <samuel.thibault@ens-lyon.org>:
>> > > Pali Rohár, le Sun 16 Mar 2014 11:16:25 +0100, a écrit :
>> > >> Hello, what happened with this patch? Is there any problem with accepting it?
>> > >
>> > > Dmitry finding time to review it, I guess.
>>
>> > Dmitry, can you look and review this patch?
>>
>> Dmitry, what happened to you, are you there? This patch is like 8
>> months old, and not too scary, either. Can you at least pinpoint some
>> typos in it, or run in through the checkpatch?
>>
>> If Dmitry does not respond, what are the next steps. Greg, could you
>> just take the patch? Linus?
>
> No, work with Dmitry please.
>

Greg, problem is that Dmitry does not respond and has not reviewed
this patch for more that 8 months. From my point of view this looks
like Dmitry does not have time for review anymore...

What to do if maintainer is busy for a long time?
Really could not you look at this patch?

https://lkml.org/lkml/2014/3/31/141

-- 
Pali Rohár
pali.rohar@gmail.com
