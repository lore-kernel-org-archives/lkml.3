Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaF3KsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:48:24 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48006 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaF3KsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:48:22 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 30 Jun 2014 12:47:44 +0200
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
Message-ID: <20140630104744.GB2486@localhost>
References: <20140625115541.GA1409@localhost>
 <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
 <20140625174109.GE1409@localhost>
 <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz>
 <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:55:10PM -0700, Bryan Wu wrote:
> On Wed, Jun 25, 2014 at 12:09 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Wed, 25 Jun 2014, Johan Hovold wrote:
> >
> >> Did you see the attribute-race series I posted? Not sure how best to
> >> handle the dependency, as those patches should probably go in through
> >> the LEDs tree, while the first patch in that series (adding the groups
> >> field) is a dependency for this patch.
> >>
> >> Jiri, how would this best be solved?
> >
> > I think the best course of action here is to gather Acks from the
> > respective maintainers, and take the whole lot trough a single tree
> > (probably the leds tree in this case) to avoid unnecessary intra-tree
> > dependencies in a rather straighforward situation like this.
> 
> I think the better place is HID/input tree, since this patch depends
> on the initial one which is not in my tree.
> I'm going to merge Johan's whole patchset and this patch probably
> depends Johan's work too.

Dmitry has ACKed the input-patch and Bryan has applied that one and the
leds-patches to his tree (of which the first one is a dependency of this
patch).

Jiri, are you saying that the gt683r-driver should go in through his
tree as well, that is all three patches including the first that you
have already applied? I just assumed your for-next branch was immutable,
but perhaps I was mistaken.

Thanks,
Johan
