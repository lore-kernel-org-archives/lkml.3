Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab3HSRit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:38:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32950 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908Ab3HSRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:38:47 -0400
Message-ID: <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Mon, 19 Aug 2013 10:38:46 -0700
In-Reply-To: <20130819172139.GA24393@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
	 <1376900735.2322.26.camel@shinybook.infradead.org>
	 <20130819125507.GA19093@srcf.ucam.org>
	 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
	 <20130819160018.GA22532@srcf.ucam.org>
	 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
	 <20130819172139.GA24393@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 18:21 +0100, Matthew Garrett wrote:
> On Mon, Aug 19, 2013 at 10:02:55AM -0700, James Bottomley wrote:
> 
> > The object of having a test suite conform to the spec is not to
> > perpetuate the cockups that occurred in round one of the implementation
> > and to force everyone to pay closer attention to what the spec says.
> > Otherwise the amount of workarounds is just going to grow without
> > bounds.
> 
> There's a benefit in having a test suite that prevents new errors from 
> being introduced, but there's no benefit in failing on errors that we 
> have to work around anyway. We have the code. We're never going to be 
> able to remove the code.

It's not about us removing the code, it's about us having an accurate
compliance test.  There are two reasons for having a fully correct
compliance test

     1. Our work arounds have unintended consequences which have knock
        on effects which mean that you don't know if a test failure is
        real or an unintended consequence of a work around.
     2. New features in specs tend to build on previous features, so
        we're going to have a hard time constructing accurate tests for
        layered features where we've done a work around for the base
        feature.

James




