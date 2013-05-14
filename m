Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3ENP0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:26:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3ENP0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:26:38 -0400
Date: Tue, 14 May 2013 16:26:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 4/7] break out mapping "freepage" code
Message-ID: <20130514152635.GV11497@suse.de>
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
 <20130507212000.59652B69@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130507212000.59652B69@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 02:20:00PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> __remove_mapping() only deals with pages with mappings, meaning
> page cache and swap cache.
> 
> At this point, the page has been removed from the mapping's radix
> tree, and we need to ensure that any fs-specific (or swap-
> specific) resources are freed up.
> 
> We will be using this function from a second location in a
> following patch.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

I used up all my complaining about naming beans in the last patch and do
not have a better suggestion for the new helper so ...

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
