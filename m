Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3GOXWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:22:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62772 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3GOXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:22:10 -0400
Date: Mon, 15 Jul 2013 16:22:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130715232209.GB24650@roeck-us.net>
References: <1373916476.2748.69.camel@dabdike>
 <20130715201943.GA22131@roeck-us.net>
 <1373925868.24167.35.camel@shinybook.infradead.org>
 <20130715220730.GA23916@roeck-us.net>
 <51E479D0.4040304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E479D0.4040304@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:38:08PM -0700, H. Peter Anvin wrote:
> On 07/15/2013 03:07 PM, Guenter Roeck wrote:
> > On Mon, Jul 15, 2013 at 11:04:28PM +0100, David Woodhouse wrote:
> >> On Mon, 2013-07-15 at 13:19 -0700, Guenter Roeck wrote:
> >>> That seems to be a bit drastic. It is quite useful to have the tag,
> >>> but maybe it should only be added by the maintainer and not in the initial
> >>> patch submission. This would ensure that the maintainer(s) made the decision.
> >>> If the original patch submitter thinks that the patch is stable material,
> >>> that information could be added in the comments section.
> >>
> >> In the case where a maintainer applies a patch with 'git am', surely
> >> they can *see* that it's cc:stable?
> >>
> > If that maintainer is careful, yes. But that isn't the point or idea. The
> > difference is that the maintainer would have to make an active decision
> > to add the cc:stable tag vs. just going along with it.
> > 
> 
> WTF?  If a maintainer applies a patch and misses that the thing had a
> Cc: <stable> tag, that maintainer should never have applied the patch in
> the first place.
> 

I agree, _should_. But again, that is not the point I was trying to make.
The keyword is _active_ decision vs. passive acceptance of a stable tag.

If the stable tag is not added by the maintainer, it can always be added to
the stable queue after the code was pushed upstream. Nothing lost but a bit
of convenience.

Guenter
