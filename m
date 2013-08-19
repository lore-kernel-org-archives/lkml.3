Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3HSQAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:00:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49805 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3HSQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:00:40 -0400
Date: Mon, 19 Aug 2013 17:00:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130819160018.GA22532@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 08:22:45AM -0700, James Bottomley wrote:
> On Mon, 2013-08-19 at 13:55 +0100, Matthew Garrett wrote:
> > On Mon, Aug 19, 2013 at 09:25:35AM +0100, David Woodhouse wrote:
> > 
> > > Every deviation from the spec (or common sense), however minor, should
> > > show up as a clear failure. Even the ones we *have* been able to work
> > > around, because we still want them *fixed*.
> > 
> > Why? It's not like we can ever stop carrying that code.
> 
> The reason for doing it is that we have a buildable reference
> implementation that's fully spec compliant we can then make the basis of
> a test suite for UEFI.

And why's that a benefit? Nobody's ever going to be able to ship an OS 
that doesn't implement these workarounds - they're de-facto part of the 
spec. It'd make more sense to document them officially.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
