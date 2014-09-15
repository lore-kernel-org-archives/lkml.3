Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIOQZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:25:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaIOQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:25:19 -0400
Message-ID: <541712C9.5020509@infradead.org>
Date: Mon, 15 Sep 2014 09:24:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC/PATCH v2 01/10] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-2-git-send-email-a.ryabinin@samsung.com> <5414F0F3.4000001@infradead.org> <5417058E.1010206@samsung.com>
In-Reply-To: <5417058E.1010206@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 08:28, Andrey Ryabinin wrote:
> On 09/14/2014 05:35 AM, Randy Dunlap wrote:
>> Following sentence is confusing.  I'm not sure how to fix it.
>>
> 
> 
> Perhaps rephrase is like this:
> 
> Do not use slub poisoning with KASan if user tracking enabled (iow slub_debug=PU).

                                       if user tracking is enabled

> User tracking info (allocation/free stacktraces) are stored inside slub object's metadata.
> Slub poisoning overwrites slub object and it's metadata with poison value on freeing.

                                            its

> So if KASan will detect use after free, allocation/free stacktraces will be overwritten

  So if KASan detects a use after free, allocation/free stacktraces are overwritten

> and KASan won't be able to print them.


Thanks.

-- 
~Randy
