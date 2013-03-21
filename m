Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab3CUQ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933845Ab3CUQ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:27:43 -0400
Date: Thu, 21 Mar 2013 18:28:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, rusty@rustcorp.com.au,
        jasowang@redhat.com, basil.gor@gmail.com, nab@risingtidesystems.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vhost/net: fix heads usage of ubuf_info
Message-ID: <20130321162813.GG1925@redhat.com>
References: <20130317124609.GA25967@redhat.com>
 <20130317.142955.1114572401286297685.davem@davemloft.net>
 <20130321060218.GB23908@redhat.com>
 <1363883028.2736.7.camel@bwh-desktop.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883028.2736.7.camel@bwh-desktop.uk.solarflarecom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:23:48PM +0000, Ben Hutchings wrote:
> On Thu, 2013-03-21 at 08:02 +0200, Michael S. Tsirkin wrote:
> > On Sun, Mar 17, 2013 at 02:29:55PM -0400, David Miller wrote:
> > > From: "Michael S. Tsirkin" <mst@redhat.com>
> > > Date: Sun, 17 Mar 2013 14:46:09 +0200
> > > 
> > > > ubuf info allocator uses guest controlled head as an index,
> > > > so a malicious guest could put the same head entry in the ring twice,
> > > > and we will get two callbacks on the same value.
> > > > To fix use upend_idx which is guaranteed to be unique.
> > > > 
> > > > Reported-by: Rusty Russell <rusty@rustcorp.com.au>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > Applied and queued up for -stable, thanks.
> > > 
> > > And thankfully you got the stable URL wrong,
> > 
> > Yes I wrote stable@kernel.org that's what an old copy
> > says here:
> > https://www.kernel.org/doc/Documentation/stable_kernel_rules.txt
> > 
> > I should have known better than look at it on the 'net.  The top
> > 'Everything you ever wanted to know about Linux 2.6 -stable releases.'
> > is a big hint that it's stale.
> > Any idea who maintains this? Better update it or remove it or redirect to git.
> 
> Rob Landley maintains it, but he's been having trouble updating it since
> all the upload mechanisms were changed on kernel.org.
> 
> (My stable maintenance scripts still match the old address, anyway.  Not
> sure about Greg's.)
> 
> Ben.

I hope you mean it will match both the old and the new address?


> -- 
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
