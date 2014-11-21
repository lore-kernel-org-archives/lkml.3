Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaKULTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:19:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60962 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaKULTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:19:19 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-47-546f1fb2baed
Message-id: <546F1FAC.1090304@samsung.com>
Date: Fri, 21 Nov 2014 14:19:08 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
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
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
 <5461B906.1040803@samsung.com>
 <20141118125843.434c216540def495d50f3a45@linux-foundation.org>
 <CAPAsAGwZtfzx5oM73bOi_kw5BqXrwGd_xmt=m6xxU6uECA+H9Q@mail.gmail.com>
 <20141120090356.GA6690@gmail.com>
 <CACT4Y+aOKzq0AzvSJrRC-iU9LmmtLzxY=pxzu8f4oT-OZk=oLA@mail.gmail.com>
 <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
 <CACT4Y+ZfWTTMn21QCU4y+rR9NXo6LZ3ZLcG5JhatGUshApPdqA@mail.gmail.com>
In-reply-to: <CACT4Y+ZfWTTMn21QCU4y+rR9NXo6LZ3ZLcG5JhatGUshApPdqA@mail.gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85O+fMWp3m7cU+GAMRhLyU0FtYaCScAkFo1QgllxtTcmpb
	M+1LQ0PTSERNc15JI50jc9PWyssybaJilnNKmTo1h5cZmpRgWZt+yG8/nt///zxfHhrnOwg/
	Ojn1llSRKk4RkB7E4LbFelTvnyYM7f0djrY6KzioqkVHol7bLwqN/1wBaN6cB9D64gxAbePZ
	GHLY7RQqsudSqKzVFzU9yCFR5fQcgYwLTgw15c9w0OjrKhJN6f5yUPP2AECfzHUYutc1gqHc
	H9scZHloxpBzspxAuQ2tGLK0t+GovvcLjlYXSnBk0D/C0Wyhk0Jj2rcU+vDHwkGbL+Y4kf5s
	rWkNsCbNV4qt06tYQ2MQW9+xiLF6bT7J6teLKbbAacXY1eFhiu1/vEWw89ZyjK0vLOGwa98+
	E+yG1oaz37vGSHaorpeK9bzqESGRpiRnSBUhZxI8kqYa0tN7YObzdzI1mPQsAFwaMuGwzFSD
	7bIPHJlqId3MZ54CqM6+scs5GKwupdzMY4JgR8vQTp5gAuDQs6UdJplguK0x7nS9GRG06qrA
	bv4Q3CyZItzsxVyEsznlrj0eNM7YaLhpt+Fu4ekS/U1VpFvwmWoCDlXe3xFcl1gca3S1aVcj
	GE5/DHKPccYfGnROvAgwmj03NP9Tmj2pOoBrgbdUlZiuvC6ThwUrxXKlKlUWnJgm14Pd59h4
	Berfn+oBDA0E+3nmKLmQzxFnKLPkPQDSuMCLd9szTcjnScRZd6SKtGsKVYpU2QMwmuunBj5c
	UffosMlWGz4YGnd8NmZflqO8qLMxofSExCu779xdg2jACp4cedMXdaw02etlXneFURItuBzX
	fnZZGrjSOlGDBcTLmtUnKVNxsUAl65gQxWbyNtONwpuRHc5Zg3j5tCmEOTAW73uws3bpQnVM
	RFbipfMObV9KbeDKFVH0YQGhTBKHBeEKpfgfFcgrffoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 10:32 AM, Dmitry Vyukov wrote:
> On Fri, Nov 21, 2014 at 2:00 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Thu, 20 Nov 2014 20:32:30 +0400 Dmitry Vyukov <dvyukov@google.com> wrote:
>>
>>> Let me provide some background first.
>>
>> Well that was useful.  Andrey, please slurp Dmitry's info into the 0/n
>> changelog?
>>
>> Also, some quantitative info about the kmemleak overhead would be
>> useful.
>>
>> In this discussion you've mentioned a few planned kasan enhancements.
>> Please also list those and attempt to describe the amount of effort and
>> complexity levels.  Partly so other can understand the plans and partly
>> so we can see what we're semi-committing ourselves to if we merge this
>> stuff.
> 
> 
> The enhancements are:
> 1. Detection of stack out-of-bounds. This is done mostly in the
> compiler. Kernel only needs adjustments in reporting.

Not so easy.
 - Because of redzones stack size needs enlarging.
 - We also need to populate shadow for addresses where kernel .data section mapped
   because  we need shadow memory for init task's stack.


> 2. Detection of global out-of-bounds. Kernel will need to process
> compiler-generated list of globals during bootstrap. Complexity is
> very low and it is isolated in Asan code.

One easy thing to do here is adding support for .init.array.* constructors.
Kernel already supports .init.array constructors, but for address sanitizer,
GCC puts constructors into .init.array.00099 section.

Just as for stack redzones, shadow needs to be populated for kernel .data addresses.
Plus shadow memory for module mapping space is also needed.


> 3. Heap quarantine (delayed reuse of heap blocks). We will need to
> hook into slub, queue freed blocks in an efficient/scalable way and
> integrate with memory shrinker (register_shrinker). This will be
> somewhat complex and touch production kernel code. Konstantin
> Khlebnikov wants to make the quarantine available independently of
> Asan, as part of slub debug that can be enabled at runtime.

If someone wants to try quarantine for slub: git://github.com/koct9i/linux/ --branch=quarantine

It has some problems with switching it on/off in runtime, besides that, it works.

> 4. Port Asan to slAb.
> 5. Do various tuning of allocator integration, redzones sizes,
> speeding up what is currently considered debug-only paths in
> malloc/free, etc.
> 6. Some people also expressed interest in ARM port.
> 

7. Compiler can't instrument assembler code, so it would be nice to have
   checks in most frequently used parts of inline assembly. Something like
    that:

	static inline void atomic_inc(atomic_t *v)
	{
		kasan_check _memory(v, sizeof(*v), WRITE);
		asm volatile(LOCK_PREFIX "incl %0"
			     : "+m" (v->counter));
	}

8. With asan's inline instrumentation bugs like NULL-ptr derefs or access to user space
turn into General protection faults. I will add a hint message into GPF handler to
indicate that GPF could be caused by NULL-ptr dereference or user memory access.
It's trivial, so I'll do this in v7.


