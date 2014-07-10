Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaGJIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:50:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22124 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaGJIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:50:26 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-5a-53be53cf6c81
Message-id: <53BE528A.1080104@samsung.com>
Date: Thu, 10 Jul 2014 12:44:58 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 13/21] mm: slub: add allocation size field
 to struct kmem_cache
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-14-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1407090933170.1384@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407090933170.1384@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xa7rng/cFG3y5qmvxe+9MVos569ew
	WSyfM5fJYsLDNnaLld3NbBbbn71lsljZ+YDVYtPja6wWf3btYLK4vGsOm8W9Nf9ZLW5f5rW4
	dGABk0XLvgtMFm2f/7Fa7Ft5HshaspHJYvGR28wW755NZrbYvGkqs8WPDY9ZHUQ9Wpp72Dz2
	Hy7y2DnrLrvHgk2lHptWdbJ5bPo0id2j6+0VJo93586xe5yY8ZvFY/OSeo+PT2+xeLzfd5XN
	48yCI+wenzfJBfBFcdmkpOZklqUW6dslcGVcfbeNteAwS0XDqZgGxgvMXYycHBICJhInD6xm
	grDFJC7cW8/WxcjFISSwlFFi49nvTBBOM5PEx7kQHbwCWhJX1p8Fs1kEVCV6Fi4A62YT0JP4
	N2s7G4gtKhAhcaDvGStEvaDEj8n3WEBsEaD66zNPg21gFrjMKtH94ipYkbBAmsSyG49YIbZt
	YZRo3z0JbAOngI3Exas9YEXMAjoS+1unsUHY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1
	NLmgOCk910ivODG3uDQvXS85P3cTIySOv+5gXHrM6hCjAAejEg/vi917goVYE8uKK3MPMUpw
	MCuJ8G6z2xcsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgZH1c6/BIu6ny+Wba9oPL/aSnhj5cNet
	mKLcOX9+VwiubnFS1b0rrP/+lZ708TDpr66OwptkxLt2+6TeW2r/M4Blcf0RNvY1LsX/RSJs
	bp7cEzT9nG7QtoNL9AJMTaSO375cOftk2AanSRL3t55Sb+CY91HocwXD+QwRtevmq5esMn66
	TaRGoV2JpTgj0VCLuag4EQDDHZ9swQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 18:33, Christoph Lameter wrote:
> On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> 
>> When caller creates new kmem_cache, requested size of kmem_cache
>> will be stored in alloc_size. Later alloc_size will be used by
>> kerenel address sanitizer to mark alloc_size of slab object as
>> accessible and the rest of its size as redzone.
> 
> I think this patch is not needed since object_size == alloc_size right?
> 

I vaguely remember there was a reason for this patch, but I can't see/recall it now.
Probably I misunderstood something. I'll drop this patch
