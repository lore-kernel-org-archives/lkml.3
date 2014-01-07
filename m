Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaAGXCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:02:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35060 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaAGXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:01:57 -0500
Date: Tue, 7 Jan 2014 23:01:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a sysctl for numa_balancing v2
Message-ID: <20140107230147.GD5990@csn.ul.ie>
References: <1389053326-29462-1-git-send-email-andi@firstfloor.org>
 <20140107135817.7f3befadebe843761d08b812@linux-foundation.org>
 <20140107221316.GF20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140107221316.GF20765@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:13:16PM +0100, Andi Kleen wrote:
> On Tue, Jan 07, 2014 at 01:58:17PM -0800, Andrew Morton wrote:
> > On Mon,  6 Jan 2014 16:08:46 -0800 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > [It turns out the documentation patch was already merged
> > > earlier. So just resending without documentation.]
> > 
> > Confused.  How could we have merged the documentation for this feature
> > but not the feature itself?
> 
> Originally all numa balancing sysctl were undocumented. I had 
> a TBD for this in my original patch. Mel then documented them,
> but also included the documentation for the new sysctl in that patch.
> Mel's documentation patch was then merged
> (as part of his regular merges I suppose), but the global sysctl
> patch wasn't.
> 

Yeah, it was an oversight on my part. I can't remember if I accidentally
dropped Andi's patch or thought it had been merged already. Sorry.

-- 
Mel Gorman
SUSE Labs
