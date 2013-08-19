Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3HSVaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:30:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54105 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3HSVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:30:23 -0400
Date: Mon, 19 Aug 2013 22:30:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130819213005.GA30211@srcf.ucam.org>
References: <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
 <1376942994.2322.39.camel@shinybook.infradead.org>
 <20130819201952.GA28740@srcf.ucam.org>
 <1376943671.2322.40.camel@shinybook.infradead.org>
 <20130819203937.GA28967@srcf.ucam.org>
 <1376946411.5087.2.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376946411.5087.2.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:06:51PM +0100, David Woodhouse wrote:

> You effectively seem to be suggesting that nothing will ever get better
> on the UEFI side, and the only benefit of the plugfest is that we get to
> see the latest brokenness and try to come up with a workaround for it
> before the consumers are afflicted with it?

Pretty much. There's a decent chance that board vendors already have the 
broken code before we end up testing against it.

> That's a really pessimistic view, and I'd really like us to be a little
> more optimistic. Things can't be, or at least can't *stay*, that bad.
> Surely?

Most vendors don't care about testing against Linux, and we can't make 
them care. What they're more likely to test against is the SCT, and 
extending that to cover a wider range of test cases (such as exhausting 
variable space) is much more likely to result in things being caught 
before anything is shipped - but even then, board vendors are going to 
take IBV code, perform "value add", never run a test suite and just make 
sure it boots Windows.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
