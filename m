Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3DJTdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:33:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:49459 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DJTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <1365622074.4235.37.camel@jlt4.sipsolutions.net>
References: <1365593728-5720-1-git-send-email-mcgrof@do-not-panic.com>
 <1365593728-5720-7-git-send-email-mcgrof@do-not-panic.com>
 <1365600139.4235.4.camel@jlt4.sipsolutions.net> <CAB=NE6UpP-X1NCTNRnoSdv_bk3ioZdg5bO1zz0U0dqeWVxZdLw@mail.gmail.com>
 <1365614413.4235.29.camel@jlt4.sipsolutions.net> <CAB=NE6VAfAvjRs0uZ=jpMjfP5Dz-zEHu3N7t8AUAofZAggrEEQ@mail.gmail.com>
 <1365618018.4235.35.camel@jlt4.sipsolutions.net> <CAB=NE6VKT11k95Szi4NmigKCgMJ1XJoU3+rACbJpnWwUpCC1EA@mail.gmail.com>
 <1365622074.4235.37.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 12:32:36 -0700
X-Google-Sender-Auth: o7jycji34LiiSj7jNQfstObsLIE
Message-ID: <CAB=NE6W8wZbwGiCCq2n2LObNreWhxd-uFU7CrX5yJw2Uik9hAg@mail.gmail.com>
Subject: Re: [PATCH 06/18] compat: backport ASYNC_DOMAIN_EXCLUSIVE()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-04-10 at 12:19 -0700, Luis R. Rodriguez wrote:
>
>> > However, it seems entirely pointless to backport just a small part of
>> > the API?
>>
>> Oh I agree don't get me wrong, however porting kernel/async.c seems
>> like a rather separate effort worth considering. As-is though I have
>> not seen any negative impact though to keep older subsystems from
>> compiling, ie its a no-op for older kernels as I see it.
>
> I guess that's what I don't understand -- I don't see usages of
> ASYNC_DOMAIN_EXCLUSIVE in any header files, and in e.g. regulator/core.c
> you'd also need the functions async_schedule_domain() etc. So where does
> this help even compiling?

You know what, sorry this was left over from when I tried to backport
the regulatory to the core of compat, and since I decided to not even
go there given that it relies on init sections on the vmlinux we can
safely discard this patch (although what I said still hold, just not
needed).

  Luis
