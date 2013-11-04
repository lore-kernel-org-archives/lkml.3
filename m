Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3KDRhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:37:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48015 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3KDRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:37:24 -0500
Date: Mon, 4 Nov 2013 12:37:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.12 for Jens Axboe
Message-ID: <20131104173711.GA7116@phenom.dumpdata.com>
References: <20130906202551.GA20743@phenom.dumpdata.com>
 <522A3A7A.8030408@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522A3A7A.8030408@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 02:26:34PM -0600, Jens Axboe wrote:
> On 09/06/2013 02:25 PM, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > I sent you a git pull a couple of weeks ago but I am not sure if
> > you pulled it. It does not look like it, so here it is again along
> > with an extra bug-fix.
> > 
> > Please git pull:
> > 
> >  git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.12
> > 
> > which will give you bug-fixes to Xen blkfront and backend driver:
> 
> Thanks, I'll get the 3.12 branch set up and pulled in. I'm behind on a
> lot of other drivers, too.

Hm, looks like you never pulled that for v3.12.

There is one more patch that Roger has provided. Do you want to pull
this branch for v3.13 nowish or wait until I put in Roger's patch?

> 
> -- 
> Jens Axboe
> 
