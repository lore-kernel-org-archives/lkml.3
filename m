Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3KERRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:17:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3KERRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:31 -0500
Date: Tue, 5 Nov 2013 12:17:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.13
Message-ID: <20131105171723.GA506@phenom.dumpdata.com>
References: <20131105165908.GA405@phenom.dumpdata.com>
 <52792410.5020200@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52792410.5020200@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:00:00AM -0700, Jens Axboe wrote:
> On 11/05/2013 09:59 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > Hey Jens,
> > 
> > Please git pull the following branch:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.13
> > 
> > 
> > which has a fix to the Xen block frontend driver. For the backends that
> > don't support persistent grants, we don't want to use the logic that would
> > use copying (needed for persistent grants). That logic existed there initially
> > but with the persistent grants code added in - it was removed (so in 3.10
> > time-frame). This adds part of it back.
> > 
> > Please pull!
> 
> Did you forget to publish it?

No, but I gave you the wrong git tree <sad>

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.13

Sorry about that.

> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
