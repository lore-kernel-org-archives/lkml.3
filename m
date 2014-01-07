Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaAGWNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:13:24 -0500
Received: from one.firstfloor.org ([193.170.194.197]:37172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:13:18 -0500
Date: Tue, 7 Jan 2014 23:13:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Add a sysctl for numa_balancing v2
Message-ID: <20140107221316.GF20765@two.firstfloor.org>
References: <1389053326-29462-1-git-send-email-andi@firstfloor.org>
 <20140107135817.7f3befadebe843761d08b812@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107135817.7f3befadebe843761d08b812@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:58:17PM -0800, Andrew Morton wrote:
> On Mon,  6 Jan 2014 16:08:46 -0800 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > [It turns out the documentation patch was already merged
> > earlier. So just resending without documentation.]
> 
> Confused.  How could we have merged the documentation for this feature
> but not the feature itself?

Originally all numa balancing sysctl were undocumented. I had 
a TBD for this in my original patch. Mel then documented them,
but also included the documentation for the new sysctl in that patch.
Mel's documentation patch was then merged
(as part of his regular merges I suppose), but the global sysctl
patch wasn't.

-Andi
