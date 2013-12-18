Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3LRQJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:09:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab3LRQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:09:39 -0500
Date: Wed, 18 Dec 2013 16:09:36 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Configurable fair allocation zone policy v3
Message-ID: <20131218160936.GX11295@suse.de>
References: <1387298904-8824-1-git-send-email-mgorman@suse.de>
 <20131217200210.GG21724@cmpxchg.org>
 <20131218061750.GK21724@cmpxchg.org>
 <20131218150038.GP11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131218150038.GP11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:00:38PM +0000, Mel Gorman wrote:
> 
> For what it's worth, this is what I've currently kicked off testes for
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git mm-pgalloc-interleave-zones-v4r12
> 

Pushed a dirty tree by accident. Now mm-pgalloc-interleave-zones-v4r13

-- 
Mel Gorman
SUSE Labs
