Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3EPD36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:29:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab3EPD3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:29:53 -0400
Message-ID: <5194529C.2040200@redhat.com>
Date: Thu, 16 May 2013 11:29:32 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Zhouping Liu <sanweidaying@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, slab: corrected the comment 'kmem_cache_alloc' to
 'slab_alloc_node'
References: <1368637812-7329-1-git-send-email-sanweidaying@gmail.com> <CAOJsxLFEP1VvNib2ORWE+CSszCo9YGEiS0d946Fgs_22yfeEOQ@mail.gmail.com>
In-Reply-To: <CAOJsxLFEP1VvNib2ORWE+CSszCo9YGEiS0d946Fgs_22yfeEOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 02:10 AM, Pekka Enberg wrote:
> On Wed, May 15, 2013 at 8:10 PM, Zhouping Liu <sanweidaying@gmail.com> wrote:
>> From: Zhouping Liu <zliu@redhat.com>
>>
>> commit 48356303ff(mm, slab: Rename __cache_alloc() -> slab_alloc())
>> forgot to update the comment 'kmem_cache_alloc' to 'slab_alloc_node'.
>>
>> Signed-off-by: Zhouping Liu <zliu@redhat.com>
>> ---
>>   mm/slab.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 8ccd296..8efb5f7 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3339,7 +3339,7 @@ done:
>>   }
>>
>>   /**
>> - * kmem_cache_alloc_node - Allocate an object on the specified node
>> + * slab_alloc_node - Allocate an object on the specified node
>>    * @cachep: The cache to allocate from.
>>    * @flags: See kmalloc().
>>    * @nodeid: node number of the target node.
> The point of the comment is to document kernel API and whereas
> slab_alloc_node() is internal to the slab allocator. Can you please
> just move it on top of kmem_cache_alloc_node() definition in the same
> file?

OK, thanks for reviewing, please check V2.

Thanks,
Zhouping
