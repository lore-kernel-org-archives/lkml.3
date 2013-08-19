Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab3HSUjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:39:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53538 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3HSUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:39:53 -0400
Date: Mon, 19 Aug 2013 21:39:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130819203937.GA28967@srcf.ucam.org>
References: <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
 <1376942994.2322.39.camel@shinybook.infradead.org>
 <20130819201952.GA28740@srcf.ucam.org>
 <1376943671.2322.40.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376943671.2322.40.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:21:11PM +0100, David Woodhouse wrote:
> On Mon, 2013-08-19 at 21:19 +0100, Matthew Garrett wrote:
> > 
> > We have no way to guarantee that. Most board vendors don't turn up to 
> > the plugfests and aren't going to run anything we ship.
> 
> Oh well, let's just wring our hands and not bother to turn up to the
> plugfest at all then. No point trying to *improve* the situation, after
> all.

The plugfests have, from our perspective, always been useful in 
identifying new implementation interpretations before hardware ships. 
But even then, it's usually too late to modify the firmware. Vendors who 
care about Linux compatibility have already tested Linux before we turn 
up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
