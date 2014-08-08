Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaHHOl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:41:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43990 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974AbaHHOl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:41:56 -0400
Date: Fri, 8 Aug 2014 15:41:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mollie Wu <mollie.wu@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to include Mailbox tree in linux-next
Message-ID: <20140808144137.GE30282@n2100.arm.linux.org.uk>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com> <20140808142912.7bf68229@canb.auug.org.au> <CAJe_ZhceR1j_b-_efJoq9Dv6X6C=UuMgyp8AofjcCvc+bQVkfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_ZhceR1j_b-_efJoq9Dv6X6C=UuMgyp8AofjcCvc+bQVkfw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 07:55:52PM +0530, Jassi Brar wrote:
> On 8 August 2014 09:59, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Jassi,
> >
> > On Wed, 6 Aug 2014 12:25:49 +0530 Jassi Brar <jaswinder.singh@linaro.org> wrote:
> >>
> >>  The framework for Mailbox has undergone 10 revisions over the last
> >> one year, which has garnered support in the form of 'Reviewed-by' and
> >> 'looks good enough to be merged in this window' from people in the CC
> >> list.
> >>
> >>   Could you please add it to linux-next?
> >> Tree:       git://git.linaro.org/landing-teams/working/fujitsu/integration.git
> >> Branch:   mailbox-for-3.17
> >> Contact:  Jassi Brar <jaswinder.singh@linaro.org>
> >
> > This is really late for v3.17.  The purpose of linux-next is to
> > discover interactions between trees before they are pulled into Linus'
> > tree and to do some cross architecture build checking.  Adding a tree
> > during the merge window is not very helpful to that.
> >
> > However if this is really going to be merged by Linus before v3.17-rc1,
> > I will add it on Monday, OK?
> >
> The patchset was deemed ready enough for this merge window. However
> some late nitpicks and bikeshedding discussions ate time and my
> confidence to send a pull request to Linus.

If it wasn't in linux-next before the merge window, you shouldn't be
thinking about sending it to Linus.  Your changes may cause conflicts
with other trees, which would be unknown - and to push it in during
a merge window without it having been visible to others is quite
unacceptable.

As Stephen says, linux-next is there to find interactions between
trees before the code hits during the merge window - so that people
know what conflicts are likely, and what the resolutions to the
conflicts should be.  If your tree is not part of linux-next, then
it's an unknown as far as everyone else is concerned.

> Upon Mark's suggestion (and the right thing to do) I wanted the patchset
> to live the cycle in linux-next.

Yes, that's the right thing to do, but you sent the request at an
inappropriate time.  The correct time to send your request would be
after 3.17-rc1 has been released, IOW after the current merge window
is over.

In general, kernel developers don't "remember" requests from one week
to the next; instead, we much prefer people send their requests at the
appropriate times in the development cycle.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
