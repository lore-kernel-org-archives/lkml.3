Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750803Ab3HSEeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:34:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16871 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3HSEeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:34:19 -0400
Message-ID: <52119FC7.5070406@oracle.com>
Date: Mon, 19 Aug 2013 12:32:07 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eternaleye@gmail.com, mgorman@suse.de,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org, axboe@kernel.dk,
        sjenning@linux.vnet.ibm.com, ngupta@vflare.org, semenzato@google.com,
        penberg@iki.fi, sonnyrao@google.com, smbarber@google.com,
        konrad.wilk@oracle.com, riel@redhat.com, kmpark@infradead.org
Subject: Re: [PATCH 0/4] mm: merge zram into zswap
References: <1376815249-6611-1-git-send-email-bob.liu@oracle.com> <20130819041044.GB26832@bbox>
In-Reply-To: <20130819041044.GB26832@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 08/19/2013 12:10 PM, Minchan Kim wrote:
> On Sun, Aug 18, 2013 at 04:40:45PM +0800, Bob Liu wrote:
>> Both zswap and zram are used to compress anon pages in memory so as to reduce
>> swap io operation. The main different is that zswap uses zbud as its allocator
>> while zram uses zsmalloc. The other different is zram will create a block
>> device, the user need to mkswp and swapon it.
>>
>> Minchan has areadly try to promote zram/zsmalloc into drivers/block/, but it may
>> cause increase maintenance headaches. Since the purpose of zswap and zram are
>> the same, this patch series try to merge them together as Mel suggested.
>> Dropped zram from staging and extended zswap with the same feature as zram.
>>
>> zswap todo:
>> Improve the writeback of zswap pool pages!
>>
>> Bob Liu (4):
>>   drivers: staging: drop zram and zsmalloc
> 
> Bob, I feel you're very rude and I'm really upset.
> 
> You're just dropping the subsystem you didn't do anything without any consensus
> from who are contriubting lots of patches to make it works well for a long time.

I apologize for that, at least I should add [RFC] in the patch title!

-- 
Regards,
-Bob
