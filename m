Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbaGAItR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:49:17 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33641 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaGAItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:49:10 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 1 Jul 2014 10:48:32 +0200
From: Johan Hovold <johan@kernel.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Johan Hovold <johan@kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R
 driver
Message-ID: <20140701084832.GC1162@localhost>
References: <20140625115541.GA1409@localhost>
 <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
 <20140625174109.GE1409@localhost>
 <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
 <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
 <20140630104744.GB2486@localhost>
 <alpine.LNX.2.00.1406301330240.28307@pobox.suse.cz>
 <CAK5ve-+-wkiG6n2Z5aPXQ7gYEDPwcAtPzjOLB+wyi+7h+8=8Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-+-wkiG6n2Z5aPXQ7gYEDPwcAtPzjOLB+wyi+7h+8=8Hg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 04:17:10PM -0700, Bryan Wu wrote:
> On Mon, Jun 30, 2014 at 4:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Mon, 30 Jun 2014, Johan Hovold wrote:
> >
> >> > I think the better place is HID/input tree, since this patch depends
> >> > on the initial one which is not in my tree.
> >> > I'm going to merge Johan's whole patchset and this patch probably
> >> > depends Johan's work too.
> >>
> >> Dmitry has ACKed the input-patch and Bryan has applied that one and the
> >> leds-patches to his tree (of which the first one is a dependency of this
> >> patch).
> >>
> >> Jiri, are you saying that the gt683r-driver should go in through his
> >> tree as well, that is all three patches including the first that you
> >> have already applied? I just assumed your for-next branch was immutable,
> >> but perhaps I was mistaken.
> >
> > Well, for-next branch is a collection of all the topic branches I am
> > queuing for the following merge window.
> >
> > I am never really rebasing it, but I can definitely not include
> > 'for-3.17/hid-gt683r' topic branch in the pile I will be sending to Linus
> > (all the scheduled branches are getting merged into 'for-linus' only when
> > merge window open). So the only potential conflict between hid.git and
> > Bryan's tree would be in linux-next (and probably there will be none, git
> > can handle duplicate patches nicely).
> >
> > So once Bryan confirms he's queued it (please preserve my Signoff from my
> > tree), then I will just not include for-3.17/hid-gt683r branch in pull
> > request to Linus and all is fine.
> >
> 
> I'm OK to merge Janne's first patch for HID GT683R through my tree
> with you guys' SOB.
> I'm also OK to merge this incremental patchset here. Please confirm it
> if I didn't misunderstand here.

That's correct. But the incremental patch set might need one more spin
before it is ready to be applied.

> Also Janne or someone, can you post the original first patch to me or
> point me where is it?

You could cherry-pick it from Jiri's for-3.17/hid-gt683r branch at

	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git

commit 4e3ed79670e0 ("HID: add support for MSI GT683R led panels").

Otherwise, the patch is here:

	http://marc.info/?l=linux-usb&m=140310755911256&w=2

Thanks,
Johan
