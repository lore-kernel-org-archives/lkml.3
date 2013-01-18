Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3ARN6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:58:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab3ARN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:58:32 -0500
Date: Fri, 18 Jan 2013 14:58:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan@kernel.org, aquini@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH] memory-hotplug: mm/Kconfig: move auto selects from
 MEMORY_HOTPLUG to MEMORY_HOTREMOVE as needed
Message-ID: <20130118135828.GD10701@dhcp22.suse.cz>
References: <1358495676-4488-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358495676-4488-1-git-send-email-linfeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-01-13 15:54:36, Lin Feng wrote:
> Besides page_isolation.c selected by MEMORY_ISOLATION under MEMORY_HOTPLUG
> is also such case, move it too.

Yes, it seems that only HOTREMOVE needs MEMORY_ISOLATION but that should
be done in a separate patch as this change is already upstream and
should be merged separately. It would also be nice to mention which
functions are we talking about. AFAICS:
alloc_migrate_target, test_pages_isolated, start_isolate_page_range and
undo_isolate_page_range.
-- 
Michal Hocko
SUSE Labs
