Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFFUPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:15:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32434 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFFUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:15:14 -0400
Message-ID: <53922148.4020605@oracle.com>
Date: Fri, 06 Jun 2014 16:15:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, jwboyer@fedoraproject.org
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: pte_present check on hugetlb_entry fix for 3.15?
References: <20140606173546.GA1869@zod> <1402080393-n2hosalz@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402080393-n2hosalz@n-horiguchi@ah.jp.nec.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 02:46 PM, Naoya Horiguchi wrote:
>>  A backported version is below.  I poked Linus about this
>> > early today privately (my fault, apologies) and he had some
>> > questions/comments on the code.
> I'm not sure the same problem really reproduces on mainline kernel without
> my page table walker patchset, because I could't reproduce it in my environment
> (Sasha, have you seen this problem on mainline kernel?)

I haven't been fuzzing the mainline kernel at any point, but this issue reproduced
with the page table walker patches reverted on -next, so I think it's safe to assume
it would reproduce on mainline.


Thanks,
Sasha
