Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3EHFaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:30:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3EHFaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:30:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,632,1363104000"; 
   d="scan'208";a="7213429"
Message-ID: <5189E39A.4040202@cn.fujitsu.com>
Date: Wed, 08 May 2013 13:33:14 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC/PATCH 3/5] mm: get_user_pages: use NON-MOVABLE pages when
 FOLL_DURABLE flag is set
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com> <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com> <51875977.4090006@cn.fujitsu.com> <5188DBCF.6040104@samsung.com>
In-Reply-To: <5188DBCF.6040104@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 13:29:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 13:29:28,
	Serialize complete at 2013/05/08 13:29:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 05/07/2013 06:47 PM, Marek Szyprowski wrote:
>
> I don't think that there was any conclusion after my patch, so I really see
> no point in submitting it again now. If you need it for Your patchset, You
> can include it directly. Just please keep my signed-off-by tag.
>

That's very kind of you. I'll keep you as the Author and your 
signed-off-by tag
if I use your patches, and will cc you.

Thanks. :)
