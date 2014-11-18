Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaKRRIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:08:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54929 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaKRRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:08:48 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-a6-546b7d1ec2fa
Message-id: <546B7D1A.2020503@samsung.com>
Date: Tue, 18 Nov 2014 20:08:42 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: akpm@linux-foundation.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
 <5461B906.1040803@samsung.com>
In-reply-to: <5461B906.1040803@samsung.com>
Content-type: text/plain; charset=koi8-r
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzH+/4ez62bXx6/ycO61dYUYso3WTVr811/9aCpluri4sphd87S
	slly5SxTJjm33S00rlu4s6RhSB4iLIdViHnKikZczEM51x/+e30+79c+738+PNJhiHLjSeKT
	xLJ4UZyQ4VMd661mH8/UW+EHGzPs0UpdAY005QYGNff/YdGA5SdA4w0PAJqfHgGoauAegaZG
	R1mUM6pk0dNKV1SWlc6gwm9jFKqenCFQWeYIjXrfahg0bPhLo08NOgLdr+8hkPL3Oo1aHzUQ
	aGYwn0LK4koCFTV/JdHsZC6JTMY8EvXpG1nUvdZKo6WKMfqEO9bWzAFcox5isc6owKZSb1xU
	O01goz6Twcb5JyxWzZgJPNvVxeK2ZysUHjfnE7goO5fGcxNfKLyg7yfxr/o+BnfqmtnTjpf4
	IdHiOEmyWOZ37Bo/VtuSTSdWUbc7M3tAGnhNqgCPB7lAmG6RqYDdBrrAnuFyRgX4PAeuBMCa
	ilLSNqQTsKI9l7RaAs4bLtYvE1amuL2wtreJsjLD+cJ1dTVjZWfuAjQbNMDm74BLucObjhPn
	AfPWuinrUZLrYOHqYMum5Midg21lmv/VzwFcKLSw1sCO2w9Xx2o3m0luHzRr+ygbe0GTYYbM
	AZx6S4l6i6beoukAqQfOYkVUovx6jDTAVy6SyhXxMb5RCVIjsL3E4htQ0hLcBDgeEG4XpFXe
	DHegRcnyFGkTgDxS6CToytpYCaJFKXfEsoSrMkWcWN4ECJ6dWxpo10+FuUSE8Dvt+T6Rr5Lq
	dtqFzZ0/s20kgwu5WyKUOfjpig9ZIvxXr0i6Tp05Sr376OgTeNIzsi4oqHXicUHcj/7D2osC
	5YEYMLZ7+ewI9z00VDJY7+p+2RxmzokweASgD55ZJiwo3xOsWZROQEXL+9SXAYvHPz984XFj
	1xEvo5CSx4r8vUmZXPQP/WvKQvACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 10:21 AM, Andrey Ryabinin wrote:
> Hi Andrew,
> 
> Now we have stable GCC(4.9.2) which supports kasan and from my point of view patchset is ready for merging.
> I could have sent v7 (it's just rebased v6), but I see no point in doing that and bothering people,
> unless you are ready to take it.
> So how should I proceed?
> 
Ping, Andrew ?

FWIW v7 will have one more patch needed for catching bad accesses in memcpy/memmove/memset.
Recently instrumentation of those functions was removed from GCC 5.0.



> Thanks,
> Andrey.
> 

