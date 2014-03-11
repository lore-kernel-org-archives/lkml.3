Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaCKTeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:34:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33552 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaCKTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:34:12 -0400
Message-ID: <531F6527.6010508@oracle.com>
Date: Tue, 11 Mar 2014 15:33:59 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, hhuang@redhat.com,
        knoel@redhat.com, aarcange@redhat.com,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
References: <5318E4BC.50301@oracle.com>	<20140306173137.6a23a0b2@cuia.bos.redhat.com>	<5318FC3F.4080204@redhat.com>	<20140307140650.GA1931@suse.de>	<20140307150923.GB1931@suse.de>	<20140307182745.GD1931@suse.de>	<20140311162845.GA30604@suse.de>	<531F3F15.8050206@oracle.com>	<531F4128.8020109@redhat.com>	<531F48CC.303@oracle.com>	<20140311180652.GM10663@suse.de>	<531F616A.7060300@oracle.com> <20140311122859.fb6c1e772d82d9f4edd02f52@linux-foundation.org>
In-Reply-To: <20140311122859.fb6c1e772d82d9f4edd02f52@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 03:28 PM, Andrew Morton wrote:
> On Tue, 11 Mar 2014 15:18:02 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>
>>> 3. Can you test with the following patches reverted please?
>>>
>>> 	e15d25d9c827b4346a36a3a78dd566d5ad353402 mm-per-thread-vma-caching-fix-fix
>>> 	e440e20dc76803cdab616b4756c201d5c72857f2 mm-per-thread-vma-caching-fix
>>> 	0d9ad4220e6d73f63a9eeeaac031b92838f75bb3 mm: per-thread vma caching
>>>
>>> The last patch will not revert cleanly (least it didn't for me) but it
>>> was just a case of git rm the two affected files, remove any include of
>>> vmacache.h and commit the rest.
>>
>> Don't see the issues I've reported before now.
>
> This is foggy.  Do you mean that all the bugs went away when
> per-thread-vma-caching was reverted?

No, sorry, just the vmacache_find and the mm/mmap.c:439 BUGs.


Thanks,
Sasha

