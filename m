Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaBRQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:42:32 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46568 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbaBRQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:42:26 -0500
Date: Tue, 18 Feb 2014 11:37:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Document exceptions to work item
 non-reentrancy guarantee
Message-ID: <20140218163705.GD30043@htj.dyndns.org>
References: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com>
 <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk>
 <5302C58E.1070903@hurleysoftware.com>
 <20140218153056.GC30043@htj.dyndns.org>
 <53038AD6.9080609@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53038AD6.9080609@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:31:18AM -0500, Peter Hurley wrote:
> >It's a pretty dumb thing to do anyway.
> 
> Fragile, yes; dumb, no. At least not from the point-of-view of the
> documentation and what the workqueue actually did. But obviously from
> your reaction, unintentional design.

Well, maybe dumb is too strong a word but these types of edge case
interfaces tend to cause subtle issues over time while being
marginally useful at best.  Sure it helps a couple odd users to write
slightly less code, but that's such a marginal gain compared to the
fragility it adds by being another one-off thing.  So, yeah, it's a
silly thing to include in an interface as widely use as workqueue and
it's more of a historical remanant than anything else at this point.

Thanks.

-- 
tejun
