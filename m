Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3KYPNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:13:46 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44198 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3KYPNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:13:43 -0500
Date: Mon, 25 Nov 2013 10:13:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, azurIt <azurit@pobox.sk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3.2 73/87] fs: buffer: move allocation failure loop into
 the allocator
Message-ID: <20131125151339.GS3556@cmpxchg.org>
References: <lsq.1385387069.559528559@decadent.org.uk>
 <lsq.1385387069.232027452@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1385387069.232027452@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Nov 25, 2013 at 01:44:29PM +0000, Ben Hutchings wrote:
> 3.2.53-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> 
> Buffer allocation has a very crude indefinite loop around waking the
> flusher threads and performing global NOFS direct reclaim because it can
> not handle allocation failures.

Please don't apply this, it's part of a bigger series and was only
tagged as a reminder.  I'll send the full series to stable when the
current cgroup instabilities are ironed out, just to be sure these
patches are not the problem.
