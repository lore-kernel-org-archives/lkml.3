Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3HUMiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:38:23 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:54121 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3HUMiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <52147FD2.9020401@broadcom.com>
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
	<20130820000336.GA15548@kroah.com>
	<CAG-2HqUkxvtJNGx0UbZVfaBNvSY-OU+=anSSnroS3AfSR9H0SA@mail.gmail.com>
	<20130820002822.GA18023@kroah.com>
	<5212F6E8.3090107@openwrt.org>
	<52132589.5000306@broadcom.com>
	<CA+5PVA7gvnfX2vnpxEGCgaAYXRvA=SME4SYZpTESqLsMkgSu=g@mail.gmail.com>
	<52147FD2.9020401@broadcom.com>
Date: Wed, 21 Aug 2013 08:38:20 -0400
X-Google-Sender-Auth: 8LpqOnloNhteN94ZVLqoUYlqPPc
Message-ID: <CA+5PVA5Wi=Xjrsb_Rh53A4NkWHe3h-gfs89dO6Zfb+6uh+G=dQ@mail.gmail.com>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Gundersen <teg@jklm.no>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 4:52 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> Hi Felix,
>>>
>>> I have been diving into root causing why brcmsmac can not handle cck
>>> fallback rates, because it should. Maybe it is better to flag no cck
>>> support
>>> and only change brcmsmac.
>>
>>
>> We have a number of users hitting this in Fedora 18 and 19 now.  We're
>> tracking it with https://bugzilla.redhat.com/show_bug.cgi?id=998080
>> and I'm sure we can find people to test easily.
>
>
> There is already another one (possibly) dealing with the same issue:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=989269
>
> One of them should probably be flagged as duplicate.
>
>
>> If you have a patch disabling cck in brcmsmac, I'd be happy to build a
>> kernel for people.  If that's going to be some time coming, perhaps
>> it's better to grab Felix's patch on a temporary basis?
>
>
> I think it is better to grab Felix's patch because as we both observed there
> is stuff missing in brcmsmac to deal with CCK rates and A-MPDU packet
> aggregation.

OK, thanks.

Felix, are you going to send that upstream?

josh
