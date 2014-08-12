Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaHLRic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaHLRia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:38:30 -0400
Date: Tue, 12 Aug 2014 19:35:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fs/proc/task_nommu.c: copy-and-paste the changes
	from task_mmu.c
Message-ID: <20140812173553.GA15112@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140811170008.GA24629@redhat.com> <53EA1D4B.5030401@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EA1D4B.5030401@uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Greg Ungerer wrote:
>
> Hi Oleg,
>
> On 12/08/14 03:00, Oleg Nesterov wrote:
>> Greg, could you review? The changes are simple, but I am not familiar
>> with NOMMU and I can't test this.
>>
>> Depends on
>>
>> 	[PATCH v2 3/7] proc: introduce proc_mem_open()
>> 	http://marc.info/?l=linux-kernel&m=140726831328943
>>
>> 	[PATCH v2 4/7] fs/proc/task_mmu.c: shift mm_access() from m_start() to proc_maps_open()
>> 	http://marc.info/?l=linux-kernel&m=140726828328929
>> 	(only because it adds proc_maps_private->mm)
>>
>> I'll also send you mbox with the previous series just in case.
>>
>> Oleg.
>>
>>   fs/proc/task_nommu.c |   65 ++++++++++++++++++++++++++++++--------------------
>>   1 files changed, 39 insertions(+), 26 deletions(-)
>
> I don't see any problems. Applied cleanly for me (to a 3.16-rc7 tree),
> compiled
> cleanly for a non-mmu m68k target, and ran with no problems I could see.
> At least I checked /proc/1/maps and that still came out fine. Is there
> anything
> else I should check?

Great, hopefully nothing else.

> I am happy to ack it:
>
> Acked-by: Greg Ungerer <gerg@uclinux.org>

Thanks a lot!

I'll send more cleanups once/if Andrew takes the pending patches.

Oleg.

