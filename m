Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBDObU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:31:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:31:16 -0500
Date: Tue, 4 Feb 2014 09:30:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Wilson <msw@linux.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-kernel@vger.kernel.org,
        Matthew Rushton <mrushton@amazon.com>, david.vrabel@citrix.com,
        Matt Wilson <msw@amazon.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [Xen-devel] xen-blkback: bug fixes
Message-ID: <20140204143055.GA3853@phenom.dumpdata.com>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
 <20140128193837.GA32072@andromeda.dapyr.net>
 <20140204063139.GA19177@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204063139.GA19177@u109add4315675089e695.ant.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:31:40PM -0800, Matt Wilson wrote:
> On Tue, Jan 28, 2014 at 03:38:37PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Jan 28, 2014 at 06:43:32PM +0100, Roger Pau Monne wrote:
> > > blkback bug fixes for memory leaks (patches 1 and 2) and a race 
> > > (patch 3).
> > 
> > They all look OK to me. I've stuck them in my 'stable/for-jens-3.14'
> > branch and are testing them now (hadn't pushed it yet).
> > 
> > Matt and Matt,
> > 
> > Could you take a look at the other two patches as well?
> 
> Sure, though somehow you didn't address your message to us, so I
> didn't see it until today.

Duh!
> 
> Matt Rushton did some review and testing on an earlier version that
> came out fine. We'll give the final series a test since there was
> still a bit of rework.

<nods>
> 
> --msw
> 
> > David, Boris,
> > 
> > Are you OK with pushing those patches out to Jens Axboe if nobody
> > gives an NACK by Friday?
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
