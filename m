Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaEWNy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:54:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51088 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaEWNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:54:55 -0400
Message-ID: <537F5320.6070402@oracle.com>
Date: Fri, 23 May 2014 09:54:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.15.0-rc6: VM_BUG_ON_PAGE(PageTail(page), page)
References: <20140522135828.GA24879@redhat.com> <537ECCDB.8080009@oracle.com> <20140523091631.GA4400@node.dhcp.inet.fi>
In-Reply-To: <20140523091631.GA4400@node.dhcp.inet.fi>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 05:16 AM, Kirill A. Shutemov wrote:
> On Fri, May 23, 2014 at 12:21:47AM -0400, Sasha Levin wrote:
>> On 05/22/2014 09:58 AM, Dave Jones wrote:
>>> Not sure if Sasha has already reported this on -next (It's getting hard
>>> to keep track of all the VM bugs he's been finding), but I hit this overnight
>>> on .15-rc6.  First time I've seen this one.
>>
>> Unfortunately I had to disable transhuge/hugetlb in my testing .config since
>> the open issues in -next get hit pretty often, and were unfixed for a while
>> now.
> 
> What THP-related is not fixed by now? collapse hung? what else?

Besides the collapse hang, we have this: https://lkml.org/lkml/2013/3/29/103 .

I know it's not a "real" bug, but DEBUG_PAGEALLOC misbehaving, but it's
still something that makes testing difficult.


Thanks,
Sasha
