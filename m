Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab3HSVKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:10:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44439 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750925Ab3HSVKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:10:45 -0400
Message-ID: <1376946644.2016.35.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Mon, 19 Aug 2013 14:10:44 -0700
In-Reply-To: <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
References: <1376944033.2016.13.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 22:34 +0200, Jiri Kosina wrote:
> On Mon, 19 Aug 2013, Joe Perches wrote:
> 
> > Patches submitted to the trivial address
> > trivial@kernel.org seem to go nowhere slowly.
> > 
> > Jiri, do you have any actual plans to try to
> > pick up these patches, notify the submitters
> > that the patches have been accepted or rejected,
> > and forward them on when appropriate?
> > 
> > Otherwise, the patches sit for _months_ without
> > any action.  That's simply too long.
> > 
> > Should another mechanism or pathway be created
> > instead?
> 
> Joe,
> 
> I disagree. Please look at what is happening in trivial.git over longer 
> period of time.

I need to look at years instead of months?

Would US Presidental election cycles or decades
be better timeframes?

> The patches I am holding off are larger series which are submitted both to 
> trivial@ and maintainers as well.

What makes something "large" to you?

This is a 7 line patch that corrects logging defects
that has had no reply from you for the last month.

https://patchwork.kernel.org/patch/2833648/

>  With such pathces, it's not clear who is 
> taking (which parts of) what, hence I hold them off for long time, and get 
> back to it eventually later.
> It's time consuming, as I have to check linux-next for those patches, 
> hence it's delayed.

No, I think you don't have to do that checking.

When I submit patches to trivial, they are submitted to you
with a simple, polite cc to the nominal maintainer(s).

You delay these patches and you also provide no feedback
as to whatever status may or may not exist to the handling
of these patches.

You're very opaque to these patches being handled or ignored.

For instance, the ctl_table typedef removal series from over
2 months ago:

https://lkml.org/lkml/2013/6/13/650

Originally, 33 patches sent to trivial (you) broken out by
subsystem with cc's to nominal maintainers.

Not a single reply to this by you to the series.

You did apply 2 of the 33 when the other nominal
maintainers supplied "acked-by"s.

I submitted another single aggregated patch with the
unapplied remainders a month ago and there's been no
action by you at all on it.

https://lkml.org/lkml/2013/7/22/600

I think that's overly long a time frame (any patch
series will bitrot) and too opaque for trivial patch
submitters to have any idea what's going on.

Also, if you're concerned that the trivial tree
wouldn't merge well in next, couldn't you use
pull+rebase to work out whether or not a patch has
already been applied in another tree?

cheers, Joe

