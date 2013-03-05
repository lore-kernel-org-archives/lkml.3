Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3CEW5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:57:14 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:43330 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEW5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:57:13 -0500
Date: Tue, 5 Mar 2013 23:57:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v1 22/33] mm/SPARC: use common help functions to
	free reserved pages
Message-ID: <20130305225711.GA12811@merkur.ravnborg.org>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com> <1362495317-32682-23-git-send-email-jiang.liu@huawei.com> <20130305195845.GB12225@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305195845.GB12225@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 08:58:46PM +0100, Sam Ravnborg wrote:
> On Tue, Mar 05, 2013 at 10:55:05PM +0800, Jiang Liu wrote:
> > Use common help functions to free reserved pages.
> 
> I like how this simplify things!
> 
> Please consider how you can also cover the HIGHMEM case,
> so map_high_region(...) is simplified too (in init_32.c).

I now see this is done in a later patch - good!

	Sam
