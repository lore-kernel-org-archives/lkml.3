Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3DONOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:14:47 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:52947 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3DONOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:14:46 -0400
Date: Mon, 15 Apr 2013 15:14:36 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [RFC PATCH v1 13/19] mm/CRIS: clean up unused VALID_PAGE()
Message-ID: <20130415131436.GC11974@axis.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
 <1365867399-21323-14-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365867399-21323-14-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 05:36:33PM +0200, Jiang Liu wrote:
> VALID_PAGE() has been removed from kernel long time ago, so clean up it.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jiang Liu <jiang.liu@huawei.com>
> Cc: linux-cris-kernel@axis.com
> Cc: linux-kernel@vger.kernel.org

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
