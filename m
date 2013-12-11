Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3LKPzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:55:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LKPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:55:03 -0500
Message-ID: <52A88ACC.4030103@oracle.com>
Date: Wed, 11 Dec 2013 10:54:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com
Subject: Re: oops in pgtable_trans_huge_withdraw
References: <20131206210254.GA7962@redhat.com> <52A8877A.10209@suse.cz>
In-Reply-To: <52A8877A.10209@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 10:40 AM, Vlastimil Babka wrote:
> On 12/06/2013 10:02 PM, Dave Jones wrote:
>> I've spent a few days enhancing trinity's use of mmap's, trying to make it
>> reproduce https://lkml.org/lkml/2013/12/4/499
>
> FYI, I managed to reproduce that using trinity today,
> trinity was from git at commit e8912cc which is from Dec 09 so I guess your enhancements were
> already there?
> kernel was linux-next-20131209
> I was running trinity -c mmap -c munmap -c mremap -c remap_file_pages -c mlock -c munlock
>
> Now I'm running with Kirill's patch, will post results later.
>
> My goal was to reproduce Sasha Levin's BUG in munlock_vma_pages_range
> https://lkml.org/lkml/2013/12/7/130
>
> Perhaps it could be related as well.
> Sasha, do you know at which commit your trinity clone was at?

Didn't think those two were related. I've hit this one when I've started fuzzing too, but
Kirill's patch solved it - so I've mostly ignored it.

Trinity is usually pulled and updated before testing, so it's at whatever the latest Dave
has pushed.


Thanks,
Sasha

