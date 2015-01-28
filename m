Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbbA2BZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64255 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbbA2BY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:59 -0500
X-AuditID: cbfee68d-f79296d000004278-0e-54c88c2c2175
Message-id: <54C88C3C.3010604@samsung.com>
Date: Wed, 28 Jan 2015 16:14:04 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Seth Jennings <sjennings@variantweb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sunae Seo <sunae.seo@samsung.com>
Subject: Re: [RFC PATCH 0/9] mm/zbud: support highmem pages
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
 <20141104163343.GA20974@cerebellum.variantweb.net>
 <20150127202440.GA13103@cerebellum.variantweb.net>
In-reply-to: <20150127202440.GA13103@cerebellum.variantweb.net>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zbV2dnhMhBmvPaFrMWb+GzeLlIU2L
	C227WSwOzl7CZHF51xw2i3tr/rNabGiZxW7x6egjNovG3e/YHDg9nk44yOSx6dMkdo8TM36z
	ePRtWcXocf1bkcfOT5tZPT5vkgtgj+KySUnNySxLLdK3S+DKmDN/DlPBKoOKT2+MGhgfqHUx
	cnBICJhILH4n3MXICWSKSVy4t56ti5GLQ0hgGaPErMUPmCESJhJ7/i2ASixilLi79D4zhPOG
	UeL29BNgVbwCWhIvt71nB7FZBFQlPu25zAqygU1AW+LQtmCQsKhAhMSHVV/ZIMoFJX5MvscC
	UiIioCMxa0cyyEhmgVOMEnOfbwMbKSxgLbH5/homiF0bGSUW7JsC1swpYC/Rsm0ZK4jNLGAr
	seD9OhYIW15i85q3YMdJCLxll+hoPs8EcZCAxLfJh1ggXpaV2HQA6jNJiYMrbrBMYBSbheSm
	WUjGzkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkMjs3cF4+4D1IUYBDkYlHt6X
	ZidChFgTy4orcw8xmgJdMZFZSjQ5Hxj/eSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MIoseszdI1jx8cKWB2rM52JqPip6NqcZyIsERRW+18ue4s/I
	4JnR8MWBJde/8bq87HzHBreGzMje1MWzdD/n3ziR93tftcZd8cD999NmXLQ1c1uzcNk9140K
	aQ77jU5paPl3LwzqmL9YWtjOL22N45k5zIWbIuqnqWx7N0tBYkn+astfqk8ylFiKMxINtZiL
	ihMB/FpWGccCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAV2dnhMhBrc+q1jMWb+GzeLlIU2L
	C227WSwOzl7CZHF51xw2i3tr/rNabGiZxW7x6egjNovG3e/YHDg9nk44yOSx6dMkdo8TM36z
	ePRtWcXocf1bkcfOT5tZPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmDFn/hymglUGFZ/eGDUwPlDrYuTkkBAwkdjzbwEbhC0mceHeeiCbi0NIYBGjxN2l95kh
	nDeMErenn2AGqeIV0JJ4ue09O4jNIqAq8WnPZdYuRg4ONgFtiUPbgkHCogIREh9WfWWDKBeU
	+DH5HgtIiYiAjsSsHckgI5kFTjFKzH2+DWyksIC1xOb7a5ggdm1klFiwbwpYM6eAvUTLtmWs
	IDazgK3EgvfrWCBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERz5z6R2MK5ssDjEKMDBqMTD+8LsRIgQa2JZcWXuIUYJDmYlEd63GkAh3pTEyqrU
	ovz4otKc1OJDjKbAEJjILCWanA9MSnkl8YbGJmZGlkZmxibmxsZK4rxK9m0hQgLpiSWp2amp
	BalFMH1MHJxSDYz29yXeX6xdcZiLUbxjtuPGWd69EROrzouvO/hDMrp5nfavj9qSW/g+3ZL8
	vzGlYRr7ET5eLV5rIe74hv9XM1NeHFQULrnR9/8EK5No0vXq9j1ezH9VNLdlXrpR9/TrPaNn
	C/zap/Dor1i/9rHDuS0B21b5xYQF8W+yCjgiMp/ZjtXSdNnb5g9KLMUZiYZazEXFiQBRytiX
	EgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/28/2015 05:24 AM, Seth Jennings wrote:
> On Tue, Nov 04, 2014 at 10:33:43AM -0600, Seth Jennings wrote:
>> On Tue, Oct 14, 2014 at 08:59:19PM +0900, Heesub Shin wrote:
>>> zbud is a memory allocator for storing compressed data pages. It keeps
>>> two data objects of arbitrary size on a single page. This simple design
>>> provides very deterministic behavior on reclamation, which is one of
>>> reasons why zswap selected zbud as a default allocator over zsmalloc.
>>>
>>> Unlike zsmalloc, however, zbud does not support highmem. This is
>>> problomatic especially on 32-bit machines having relatively small
>>> lowmem. Compressing anonymous pages from highmem and storing them into
>>> lowmem could eat up lowmem spaces.
>>>
>>> This limitation is due to the fact that zbud manages its internal data
>>> structures on zbud_header which is kept in the head of zbud_page. For
>>> example, zbud_pages are tracked by several lists and have some status
>>> information, which are being referenced at any time by the kernel. Thus,
>>> zbud_pages should be allocated on a memory region directly mapped,
>>> lowmem.
>>>
>>> After some digging out, I found that internal data structures of zbud
>>> can be kept in the struct page, the same way as zsmalloc does. So, this
>>> series moves out all fields in zbud_header to struct page. Though it
>>> alters quite a lot, it does not add any functional differences except
>>> highmem support. I am afraid that this kind of modification abusing
>>> several fields in struct page would be ok.
>>
>> Hi Heesub,
>>
>> Sorry for the very late reply.  The end of October was very busy for me.
>>
>> A little history on zbud.  I didn't put the metadata in the struct
>> page, even though I knew that was an option since we had done it with
>> zsmalloc. At the time, Andrew Morton had concerns about memmap walkers
>> getting messed up with unexpected values in the struct page fields.  In
>> order to smooth zbud's acceptance, I decided to store the metadata
>> inline in the page itself.
>>
>> Later, zsmalloc eventually got accepted, which basically gave the
>> impression that putting the metadata in the struct page was acceptable.
>>
>> I have recently been looking at implementing compaction for zsmalloc,
>> but having the metadata in the struct page and having the handle
>> directly encode the PFN and offset of the data block prevents
>> transparent relocation of the data. zbud has a similar issue as it
>> currently encodes the page address in the handle returned to the user
>> (also the limitation that is preventing use of highmem pages).
>>
>> I would like to implement compaction for zbud too and moving the
>> metadata into the struct page is going to work against that. In fact,
>> I'm looking at the option of converting the current zbud_header into a
>> per-allocation metadata structure, which would provide a layer of
>> indirection between zbud and the user, allowing for transparent
>> relocation and compaction.
>
> I had some downtime and started thinking about this again today (after
> 3 months).
>
> Upon further reflection, I really like this and don't think that it
> inhibits introducing compaction later.
>
> There are just a few places that look messy or problematic to me:
>
> 1. the use of page->private and masking the number of chunks for both
> buddies into it (see suggestion for overlay struct below)
> 2. the use of the second double word &page->index to store a list_head
>
> #2 might be problematic because, IIRC, memmap walkers will check _count
> (or _mapcount).  I think we ran into this in zsmalloc.
>
> Initially, when working on zsmalloc, I just created a structure that
> overlaid the struct page in the memmap, reserving the flags and _count
> areas, so that I wouldn't have to be bound by the field names/boundaries
> in the struct page.
>
> IIRC, Andrew was initially against that, but he was also against the
> whole idea of using the struct page fields for random stuff... I that
> ended up being accepted.
>
> This code looks really good!  I think with a little cleanup and finding
> a way to steer clear of using the _count part of the structure, this
> will be great.

Thanks for your comments! I will try to address problems you pointed and 
post a new patchset hopefully soon.

regards,
heesub

>
> Sorry for dismissing it earlier.  Didn't give it enough credit.
>
> Thanks,
> Seth
>
>>
>> However, I do like the part about letting zbud use highmem pages.
>>
>> I have something in mind that would allow highmem pages _and_ move
>> toward something that would support compaction.  I'll see if I can put
>> it into code today.
>>
>> Thanks,
>> Seth
>>
>>>
>>> Heesub Shin (9):
>>>    mm/zbud: tidy up a bit
>>>    mm/zbud: remove buddied list from zbud_pool
>>>    mm/zbud: remove lru from zbud_header
>>>    mm/zbud: remove first|last_chunks from zbud_header
>>>    mm/zbud: encode zbud handle using struct page
>>>    mm/zbud: remove list_head for buddied list from zbud_header
>>>    mm/zbud: drop zbud_header
>>>    mm/zbud: allow clients to use highmem pages
>>>    mm/zswap: use highmem pages for compressed pool
>>>
>>>   mm/zbud.c  | 244 ++++++++++++++++++++++++++++++-------------------------------
>>>   mm/zswap.c |   4 +-
>>>   2 files changed, 121 insertions(+), 127 deletions(-)
>>>
>>> --
>>> 1.9.1
>>>
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
