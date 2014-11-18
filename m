Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaKRVdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:33:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:2497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaKRVdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418336962"
Message-ID: <546BBAE2.306@intel.com>
Date: Tue, 18 Nov 2014 13:32:18 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com> <5461B906.1040803@samsung.com> <20141118125843.434c216540def495d50f3a45@linux-foundation.org> <20141118211531.GH12538@two.firstfloor.org>
In-Reply-To: <20141118211531.GH12538@two.firstfloor.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 01:15 PM, Andi Kleen wrote:
>> > If kasan will permit us to remove kmemcheck/debug_pagealloc/slub_debug
>> > then that tips the balance a little.  What's the feasibility of that?
> Maybe removing kmemcheck. slub_debug/debug_pagealloc are simple, and are in
> different niches (lower overhead debugging)

Yeah, slub_debug can be turned on at runtime in production kernels so
it's in a completely different category.
