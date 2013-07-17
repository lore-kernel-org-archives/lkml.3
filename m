Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3GQPPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:15:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49048 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3GQPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:15:13 -0400
Date: Wed, 17 Jul 2013 11:08:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130717150857.GA2291@tuxdriver.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373951852.2148.9.camel@dabdike>
 <20130716062058.GB19052@kroah.com>
 <1373960616.2148.34.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373960616.2148.34.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:43:36AM +0400, James Bottomley wrote:
> On Mon, 2013-07-15 at 23:20 -0700, Greg KH wrote:
> 
> > I think the real stable issue that _everyone_ keeps ignoring, is my
> > original complaint, in that people are using the -rc1 merge window to
> > get fixes in they should have sent to Linus for .0.
> 
> You mean we delay fixes to the merge window (tagged for stable) because
> we can't get them into Linus' tree at -rc5 on?  Guilty ... that's
> because the friction for getting stuff in rises.  It's a big fight to
> get something marginal in after -rc5 ... it's easy to silently tag it
> for stable (did I mention that I think the tag part enables this
> behaviour?).

I'll just chime-in here and agree that I have delayed minor fixes,
preventing them from being merged during an -rc6 or -rc7 but tagging
them for -stable.  It has long been 'tradition' (at least in the
networking space) that fixes so late in the cycle should tend to be
really small (i.e. "one-liners") and/or really, really, important.
In other words, they need to avoid potentially delaying a release
unless they are absolutely necessary.

Fixes merged early in the next release cycle at least have a fighting
chance of getting some testing before getting into the hands of the
unwashed masses.  If they have problems in 3.<previous>.1 then they
can still be reverted in -stable, but they can never be removed from
the .0 release -- does this matter?  I'm not sure.  Is having a flood
of fixes in x.y.1 any worse than having to got to an -rc8 or an -rc9?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
