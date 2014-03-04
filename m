Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaCDWrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:47:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41860 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaCDWrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:47:02 -0500
Message-ID: <531657DC.4050204@oracle.com>
Date: Tue, 04 Mar 2014 17:46:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] mm: add pte_present() check on existing hugetlb_entry
 callbacks
References: <53126861.7040107@oracle.com> <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5314E0CD.6070308@oracle.com> <5314F661.30202@oracle.com> <1393968743-imrxpynb@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393968743-imrxpynb@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 04:32 PM, Naoya Horiguchi wrote:
> # sorry if duplicate message
> 
> On Mon, Mar 03, 2014 at 04:38:41PM -0500, Sasha Levin wrote:
>> On 03/03/2014 03:06 PM, Sasha Levin wrote:
>>> On 03/03/2014 12:02 AM, Naoya Horiguchi wrote:
>>>> Hi Sasha,
>>>>
>>>>>> I can confirm that with this patch the lockdep issue is gone. However, the NULL deref in
>>>>>> walk_pte_range() and the BUG at mm/hugemem.c:3580 still appear.
>>>> I spotted the cause of this problem.
>>>> Could you try testing if this patch fixes it?
>>>
>>> I'm seeing a different failure with this patch:
>>
>> And the NULL deref still happens.
> 
> I don't yet find out the root reason why this issue remains.
> So I tried to run trinity myself but the problem didn't reproduce.
> (I did simply like "./trinity --group vm --dangerous" a few hours.)
> Could you show more detail or tips about how the problem occurs?

I run it as root in a disposable vm, that may be the difference here.


Thanks,
Sasha

