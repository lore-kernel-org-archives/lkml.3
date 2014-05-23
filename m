Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaEWFy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:54:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaEWFy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:54:57 -0400
Message-ID: <537EE2AF.4070307@suse.cz>
Date: Fri, 23 May 2014 07:54:55 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.15.0-rc6: VM_BUG_ON_PAGE(PageTail(page), page)
References: <20140522135828.GA24879@redhat.com> <537ECCDB.8080009@oracle.com>
In-Reply-To: <537ECCDB.8080009@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.5.2014 6:21, Sasha Levin wrote:
> On 05/22/2014 09:58 AM, Dave Jones wrote:
>> Not sure if Sasha has already reported this on -next (It's getting hard
>> to keep track of all the VM bugs he's been finding), but I hit this overnight
>> on .15-rc6.  First time I've seen this one.
> Unfortunately I had to disable transhuge/hugetlb in my testing .config since
> the open issues in -next get hit pretty often, and were unfixed for a while
> now.

Meh, I lost track. We should really consider something like bugzilla for 
this, IMHO.

> Keeping them enabled just made it impossible to test anything else.
>
>
> Thanks,
> Sasha
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

