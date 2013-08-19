Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3HSRC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:02:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32797 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab3HSRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:02:57 -0400
Message-ID: <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Mon, 19 Aug 2013 10:02:55 -0700
In-Reply-To: <20130819160018.GA22532@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
	 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
	 <20130819160018.GA22532@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 17:00 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 08:22:45AM -0700, James Bottomley wrote:
> > On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> > > On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> > > 
> > > > Every deviation from the spec (or common sense), however minor, should
> > > > show up as a clear failure. Even the ones we *have* been able to work
> > > > around, because we still want them *fixed*.
> > > 
> > > Why? It's not like we can ever stop carrying that code.
> > 
> > The reason for doing it is that we have a buildable reference
> > implementation that's fully spec compliant we can then make the basis of
> > a test suite for UEFI.
> 
> And why's that a benefit? Nobody's ever going to be able to ship an OS 
> that doesn't implement these workarounds - they're de-facto part of the 
> spec. It'd make more sense to document them officially.

The object of having a test suite conform to the spec is not to
perpetuate the cockups that occurred in round one of the implementation
and to force everyone to pay closer attention to what the spec says.
Otherwise the amount of workarounds is just going to grow without
bounds.

James


