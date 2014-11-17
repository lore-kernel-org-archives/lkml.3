Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaKQVck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:32:40 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:34277 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaKQVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:32:38 -0500
Date: Mon, 17 Nov 2014 16:32:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move swp_entry_t definition to
 include/linux/mm_types.h
Message-ID: <20141117213233.GI23126@htj.dyndns.org>
References: <20141117211723.GH23126@htj.dyndns.org>
 <20141117132900.da426ddb56a3eeb01a484b38@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117132900.da426ddb56a3eeb01a484b38@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 01:29:00PM -0800, Andrew Morton wrote:
> Looks OK to me.  Do you have some patch which depends on this?  If
> so, please merge this via whatever tree carries that patch?

The dependant ones will have to go through -mm anyway, so applying to
-mm should be fine.

Thanks.

-- 
tejun
