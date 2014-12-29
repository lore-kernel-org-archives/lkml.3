Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaL2OM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:12:58 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56193 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaL2OM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:12:57 -0500
Message-ID: <54A1616B.4000005@gmail.com>
Date: Mon, 29 Dec 2014 15:12:59 +0100
From: Stefan Strogin <stefan.strogin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Safonov Dmitry <d.safonov@partner.samsung.com>,
        SeongJae Park <sj38.park@gmail.com>,
        "Stefan I. Strogin" <s.strogin@partner.samsung.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 3/3] cma: add functions to get region pages counters
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com> <alpine.DEB.2.10.1412271616450.1819@hxeon> <54A0ED19.1040003@partner.samsung.com>
In-Reply-To: <54A0ED19.1040003@partner.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.12.2014 06:56, Safonov Dmitry пишет:
>
> On 12/27/2014 10:18 AM, SeongJae Park wrote:
>> Hello,
>>
>> How about 'CMA Region' rather than 'CMARegion'?
> Sure.
>

I would like "CMA area..." :)
Or rather "CMA area #%u: base 0x%llx...",
		   cma - &cma_areas[0],
		   (unsigned long long)cma_get_base(cma),

