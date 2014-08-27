Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbaH0MO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:14:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbaH0MO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:14:27 -0400
Message-ID: <53FDCB8F.40001@oracle.com>
Date: Wed, 27 Aug 2014 08:14:07 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: kernel BUG at mm/rmap.c:530
References: <53F487EB.7070703@oracle.com> <20140820140247.C729CE00A3@blue.fi.intel.com>
In-Reply-To: <20140820140247.C729CE00A3@blue.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 10:02 AM, Kirill A. Shutemov wrote:
> Sasha Levin wrote:
>> > Hi all,
>> > 
>> > While fuzzing with trinity inside a KVM tools guest running the latest -next
>> > kernel, I've stumbled on the following spew:
>> > 
>> > [ 2581.180086] kernel BUG at mm/rmap.c:530!
> Page is mapped where it shouldn't be. Or vma/struct page/pgtable is corrupted.
> Basically, I have no idea what happend :-P
> 
> We really should dump page and vma info there. It's strange we don't have
> dump_vma() helper yet.
> 

It just happened again, I'll work on that dump_vma helper... :/


Thanks,
Sasha
