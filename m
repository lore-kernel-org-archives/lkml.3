Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab3GPAVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:21:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55701 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758334Ab3GPAVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:21:34 -0400
X-Sasl-enc: qjYkFEExAbX3L5RKsohEib0Rdjfq8oox1ZaFmIQpHgSX 1373934091
Date: Mon, 15 Jul 2013 17:21:28 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130716002128.GA9278@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715201943.GA22131@roeck-us.net>
 <1373925868.24167.35.camel@shinybook.infradead.org>
 <20130715220730.GA23916@roeck-us.net>
 <51E479D0.4040304@zytor.com>
 <20130715232209.GB24650@roeck-us.net>
 <51E49036.5000901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E49036.5000901@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 05:13:42PM -0700, H. Peter Anvin wrote:
> On 07/15/2013 04:22 PM, Guenter Roeck wrote:
> > 
> > I agree, _should_. But again, that is not the point I was trying to make.
> > The keyword is _active_ decision vs. passive acceptance of a stable tag.
> > 
> > If the stable tag is not added by the maintainer, it can always be added to
> > the stable queue after the code was pushed upstream. Nothing lost but a bit
> > of convenience.
> > 
> 
> ... and yet another opportunity for things to fall between the cracks,
> which is in my opinion MUCH more likely than something inappropriate
> being tagged Cc: stable.
> 
> However, it doesn't seem to happen too often, but it does underscore the
> need for a maintainer to be able to *retroactively* NAK a patch for
> stable, if it is uncovered that it isn't appropriate after all.

I give maintainers 2 different chances to NAK a patch, and if they miss
those, I can also easily revert a patch that got applied and do a new
release, which I have done in the past.

greg k-h
