Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaCOACq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 20:02:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48781 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbaCOACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 20:02:44 -0400
X-Sasl-enc: DxpbLVHVDbBwGlMrkcgPvj7Fnx+qSeMjz4f5qMmSkNsg 1394841763
Date: Sat, 15 Mar 2014 00:03:43 +0000
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140315000343.GD5687@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <1394596541.4840.70.camel@pasglop>
 <20140312113742.GM28112@sirena.org.uk>
 <1394654396.4840.94.camel@pasglop>
 <20140312200232.GA22332@htj.dyndns.org>
 <1394655292.4840.97.camel@pasglop>
 <20140312202102.GB22332@htj.dyndns.org>
 <1394671056.4840.103.camel@pasglop>
 <1394748895.15098.16.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394748895.15098.16.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:14:55AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-03-13 at 11:37 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2014-03-12 at 16:21 -0400, Tejun Heo wrote:
> > > It's a series of rather complex patches.  I really don't think
> > > duplicating them is a good idea.  We can either resurrect the old API
> > > to kill it again or set up a merge branch which I don't think is too
> > > unusual in situations like this.
> > 
> > Right, a topic branch that gets merged in both driver-core-next and
> > powerpc-next.
> 
> Just want to make sure we agree ... ie, the offending commit is already
> in powerpc-next on my side and I can't really back it out (I could
> revert it though).

You can pull in driver-core-next into your tree if you want, it's not
going to be reverted, and will be sent to Linus for 3.15-rc1, so you can
base your work on it and fix up the api usage in your tree that way.

thanks,

greg k-h
