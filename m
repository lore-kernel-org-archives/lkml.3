Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaF3XRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:17:35 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44948 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaF3XRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1406301330240.28307@pobox.suse.cz>
References: <20140625115541.GA1409@localhost> <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
 <20140625174109.GE1409@localhost> <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
 <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
 <20140630104744.GB2486@localhost> <alpine.LNX.2.00.1406301330240.28307@pobox.suse.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 30 Jun 2014 16:17:10 -0700
Message-ID: <CAK5ve-+-wkiG6n2Z5aPXQ7gYEDPwcAtPzjOLB+wyi+7h+8=8Hg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R driver
To: Jiri Kosina <jkosina@suse.cz>
Cc: Johan Hovold <johan@kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 4:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 30 Jun 2014, Johan Hovold wrote:
>
>> > I think the better place is HID/input tree, since this patch depends
>> > on the initial one which is not in my tree.
>> > I'm going to merge Johan's whole patchset and this patch probably
>> > depends Johan's work too.
>>
>> Dmitry has ACKed the input-patch and Bryan has applied that one and the
>> leds-patches to his tree (of which the first one is a dependency of this
>> patch).
>>
>> Jiri, are you saying that the gt683r-driver should go in through his
>> tree as well, that is all three patches including the first that you
>> have already applied? I just assumed your for-next branch was immutable,
>> but perhaps I was mistaken.
>
> Well, for-next branch is a collection of all the topic branches I am
> queuing for the following merge window.
>
> I am never really rebasing it, but I can definitely not include
> 'for-3.17/hid-gt683r' topic branch in the pile I will be sending to Linus
> (all the scheduled branches are getting merged into 'for-linus' only when
> merge window open). So the only potential conflict between hid.git and
> Bryan's tree would be in linux-next (and probably there will be none, git
> can handle duplicate patches nicely).
>
> So once Bryan confirms he's queued it (please preserve my Signoff from my
> tree), then I will just not include for-3.17/hid-gt683r branch in pull
> request to Linus and all is fine.
>

I'm OK to merge Janne's first patch for HID GT683R through my tree
with you guys' SOB.
I'm also OK to merge this incremental patchset here. Please confirm it
if I didn't misunderstand here.

Also Janne or someone, can you post the original first patch to me or
point me where is it?

Thanks,
-Bryan
