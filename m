Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaAFNJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:09:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaAFNJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:09:16 -0500
Date: Mon, 6 Jan 2014 13:09:12 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Calculate effective load even if local weight is 0
Message-ID: <20140106130912.GD6178@suse.de>
References: <20140106113912.GC6178@suse.de>
 <20140106123420.GJ31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140106123420.GJ31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:34:20PM +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 11:39:12AM +0000, Mel Gorman wrote:
> > (Rik, you authored this patch so it should be sent from you and needs a
> > signed-off assuming people are ok with the changelog.)
> 
> Where did all this take place? I saw the initial email I think but then
> nothing..
> 
> Not that I was reading much email the past two weeks anyway :-)

Much of the discussion was on the bugzilla entry
https://bugzilla.kernel.org/show_bug.cgi?id=67601 which is rare but it
happens. In retrospect, I should also have included a blurb saying that
the patch resolved the bug but it's not that big a deal.

-- 
Mel Gorman
SUSE Labs
