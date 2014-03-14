Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaCNNAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:00:08 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46879 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaCNNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:00:05 -0400
Date: Fri, 14 Mar 2014 09:00:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Brown <broonie@kernel.org>, Greg KH <greg@kroah.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140314130002.GB12613@htj.dyndns.org>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

Hmmm... reverting may be an option too but I don't think fixing it
retroactively in a new branch should be okay too.

Thanks.

-- 
tejun
