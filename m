Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaAYHVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:21:42 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47620 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAYHVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:21:39 -0500
Message-ID: <52E30FAA.500@hp.com>
Date: Fri, 24 Jan 2014 18:13:14 -0700
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, T Makphaibulchoke <tmac@hp.com>
CC: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
References: <1377186876-57291-1-git-send-email-tmac@hp.com>	<1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com>
In-Reply-To: <87fvodcb65.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 02:38 PM, Andi Kleen wrote:
> T Makphaibulchoke <tmac@hp.com> writes:
> 
>> The patch consists of three parts.
>>
>> The first part changes the implementation of both the block and hash chains of
>> an mb_cache from list_head to hlist_bl_head and also introduces new members,
>> including a spinlock to mb_cache_entry, as required by the second part.
> 
> spinlock per entry is usually overkill for larger hash tables.
> 
> Can you use a second smaller lock table that just has locks and is 
> indexed by a subset of the hash key. Most likely a very small 
> table is good enough.
> 
> Also I would be good to have some data on the additional memory consumption.
> 
> -Andi
> 

Thanks Andi for the comments.  Will look into that.

Thanks,
Mak.

