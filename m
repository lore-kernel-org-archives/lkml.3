Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3LCSMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:12:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3LCSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:12:45 -0500
Date: Tue, 3 Dec 2013 13:03:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>, xen-devel@lists.xenproject.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Roger Pau Monne <roger.pau@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2] xen/block: Correctly define structures in public
 headers on ARM32 and ARM64
Message-ID: <20131203180333.GH3734@phenom.dumpdata.com>
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
 <20131203160018.67542a53@alan.etchedpixels.co.uk>
 <529E04AB.5060304@linaro.org>
 <20131203163228.3313dff8@alan.etchedpixels.co.uk>
 <1386088897.13256.66.camel@kazak.uk.xensource.com>
 <20131203170310.7099a706@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203170310.7099a706@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:03:10PM +0000, One Thousand Gnomes wrote:
> > itself. The protocol is defined by an entity which is external to Linux.
> > If this had been a bug in the IP protocol handling we would fix it and
> > move on. This case is no different IMHO.
> 
> Actually that is quite untrue. We are *very* careful that we can talk to
> other internet nodes that speak broken versions of TCP. There have even
> been changes made to protocol definitions during initial research to
> avoid tripping bugs in existing implementations.
> 
> > Once we set the ABI in stone then this is the sort of thing we will care
> > very much about (as we have done for many years on x86). Until then it
> > is not.
> 
> Maybe Xen doesn't, but perhaps Linux doesn't wish to be tarred with the
> same brush. What Xen decides is the official protocol is Xen's decision.
> What a Linux guest does to keep compatibility ought to follow what Linux
> does as policy.

I believe that this patch does not alter the x86 protocols.
Only the ARM based ones which are still in Technical Preview.

> 
> Alan
