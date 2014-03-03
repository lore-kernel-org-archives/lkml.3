Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCCViy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:38:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaCCViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:38:52 -0500
Message-ID: <5314F661.30202@oracle.com>
Date: Mon, 03 Mar 2014 16:38:41 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: add pte_present() check on existing hugetlb_entry
 callbacks
References: <53126861.7040107@oracle.com> <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5314E0CD.6070308@oracle.com>
In-Reply-To: <5314E0CD.6070308@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 03:06 PM, Sasha Levin wrote:
> On 03/03/2014 12:02 AM, Naoya Horiguchi wrote:
>> Hi Sasha,
>>
>>> >I can confirm that with this patch the lockdep issue is gone. However, the NULL deref in
>>> >walk_pte_range() and the BUG at mm/hugemem.c:3580 still appear.
>> I spotted the cause of this problem.
>> Could you try testing if this patch fixes it?
>
> I'm seeing a different failure with this patch:

And the NULL deref still happens.


Thanks,
Sasha
