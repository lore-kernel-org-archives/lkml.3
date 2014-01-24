Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaAXPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:44:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbaAXPol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:44:41 -0500
Date: Fri, 24 Jan 2014 15:44:38 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 9/9] numa,sched: define some magic numbers
Message-ID: <20140124154438.GC4963@suse.de>
References: <1390342811-11769-1-git-send-email-riel@redhat.com>
 <1390342811-11769-10-git-send-email-riel@redhat.com>
 <20140121185826.26247d89@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140121185826.26247d89@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 06:58:26PM -0500, Rik van Riel wrote:
> On Tue, 21 Jan 2014 17:20:11 -0500
> riel@redhat.com wrote:
> 
> > From: Rik van Riel <riel@redhat.com>
> > 
> > Cleanup suggested by Mel Gorman. Now the code contains some more
> > hints on what statistics go where.
> > 
> > Suggested-by: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> ... and patch fatigue hit, causing me to mess up this simple
> patch with no functional changes (which is why I did not test
> it yet).
> 
> Here is one that compiles.
> 
> ---8<---
> 
> Subject: numa,sched: define some magic numbers
> 
> Cleanup suggested by Mel Gorman. Now the code contains some more
> hints on what statistics go where.
> 
> Suggested-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
