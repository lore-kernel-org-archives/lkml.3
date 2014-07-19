Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaGSH5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:57:11 -0400
Received: from 8bytes.org ([81.169.241.247]:49139 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbaGSH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:57:09 -0400
Date: Sat, 19 Jul 2014 09:57:08 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/6] PM / Hibernate: Create a Radix-Tree to store memory
 bitmap
Message-ID: <20140719075707.GI30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <1405684643-30234-2-git-send-email-joro@8bytes.org>
 <7231480.jWHmWTNGCG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7231480.jWHmWTNGCG@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:00:39AM +0200, Rafael J. Wysocki wrote:
> > +/*
> > + *	alloc_rtree_node - Allocate a new node and add it to the radix
> > + *			   tree.
> 
> Please make this a single line.
> 
> > +static int add_rtree_block(struct mem_zone_bm_rtree *zone, gfp_t gfp_mask,
> > +			   int safe_needed, struct chain_allocator *ca)
> > +{
> > +	struct rtree_node *node, *block, **dst;
> > +	unsigned int levels_needed, block_nr;
> > +	int i;
> > +
> > +	block_nr	= zone->blocks;
> 
> This isn't proper kernel coding style.  Please use spaces as separators
> before the "=" here and elsewhere.

Thanks for your comments, will fix this and resend next week.


	Joerg

