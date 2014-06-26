Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaFZXXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 19:23:54 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42286 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFZXXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 19:23:53 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53ACAB82.6020201@lge.com>
Date: Fri, 27 Jun 2014 08:23:46 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC] CMA page migration failure due to buffers on bh_lru
References: <53A8D092.4040801@lge.com> <xa1td2dvmznq.fsf@mina86.com>
In-Reply-To: <xa1td2dvmznq.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-06-27 오전 12:57, Michal Nazarewicz 쓴 글:
> On Tue, Jun 24 2014, Gioh Kim <gioh.kim@lge.com> wrote:
>> Hello,
>>
>> I am trying to apply CMA feature for my platform.
>> My kernel version, 3.10.x, is not allocating memory from CMA area so that I applied
>> a Joonsoo Kim's patch (https://lkml.org/lkml/2014/5/28/64).
>> Now my platform can use CMA area effectively.
>>
>> But I have many failures to allocate memory from CMA area.
>> I found the same situation to Laura Abbott's patch descrbing,
>> https://lkml.org/lkml/2012/8/31/313,
>> that releases buffer-heads attached at CPU's LRU list.
>>
>> If Joonsoo's patch is applied and/or CMA feature is applied more and more,
>> buffer-heads problem is going to be serious definitely.
>>
>> Please look into the Laura's patch again.
>> I think it must be applied with Joonsoo's patch.
>
> Just to make sure I understood you correctly, you're saying Laura's
> patch at <https://lkml.org/lkml/2012/8/31/313> fixes your issue?
>

Yes, it is.
