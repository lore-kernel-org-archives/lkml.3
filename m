Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3CEQwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:52:43 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:34973 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3CEQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:52:42 -0500
Date: Tue, 5 Mar 2013 17:50:02 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
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
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [RFC PATCH v1 04/33] mm/avr32: use common help functions to
 free reserved pages
Message-ID: <20130305165002.GA4621@samfundet.no>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
 <1362495317-32682-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362495317-32682-5-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 05 Mar 2013 22:54:47 +0800 or thereabout, Jiang Liu wrote:
> Use common help functions to free reserved pages.
>

AFAICT it looks good, thanks for updating.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> ---
>  arch/avr32/mm/init.c |   24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)

<snipp diff>

-- 
Hans-Christian Egtvedt
