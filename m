Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaETRrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:47:14 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62587 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaETRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:47:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18EVSON7/8OfLy6keO8WquZbYB9I0dFo5g=
X-DKIM: OpenDKIM Filter v2.0.1 titan AD26857B3CC
Date: Tue, 20 May 2014 13:47:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140520174707.GB8664@titan.lakedaemon.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
 <20140520144757.GA8664@titan.lakedaemon.net>
 <20140520102411.413d565d@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520102411.413d565d@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:24:11AM -0600, Jake Edge wrote:
> On Tue, 20 May 2014 10:47:57 -0400 Jason Cooper wrote:
> 
> > Do you have any other series pending for this driver?
> 
> No and I won't be doing anything else for the next couple of days --
> some darn weekly edition to deal with :)

:)

> It seems like most of the straightforward stuff has been dealt with at
> this point.  That rats nest of ifdefs in skein_block.c needs attention,
> but some kind of tests are needed to ensure nothing breaks before
> digging into that ...

Something like objdiff [1]?  It landed in v3.15-rc1, so you can use it
from staging/staging-next.

I'd also like to consolidate all the macros that are declared in the
middle of functions and such.  After that, test vectors and crypto API
integration.

thx,

Jason.

[1] https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/scripts/objdiff?id=79192ca8ebd9a25c583aa46024a250fef1e7766f
