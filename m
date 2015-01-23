Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbbAWKOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:14:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47190 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbAWKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:14:30 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-20-54c21e72e45f
Message-id: <54C21EFD.6080900@samsung.com>
Date: Fri, 23 Jan 2015 13:14:21 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v9 00/17] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
 <54C042D2.4040809@oracle.com>
 <CAPAsAGyXo=AMCU-2TbrrY=MPorg+Nd+WYS5nCAcjELZs91r4AQ@mail.gmail.com>
 <CAPAsAGyMyq_anQjErLa=L-0K3KmghMjoqzi0AdZOADTAECn1HA@mail.gmail.com>
 <54C16F99.2000006@oracle.com>
In-reply-to: <54C16F99.2000006@oracle.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0hTcRzH+Z+7q8HxsjoJWQgSCM20oj8hYj0dkEJQwoLKqWMaTm3HSeZD
	3lCcJaLo2pBceEHXSt1WppTOKU102VyakJecOU1ympomiNYuD/n2+X35Xl5+FBrgxIKpjKxc
	sSxLlBlK8LDRA8vEWVmIOfFc5dwZuPdehcOGDh0Bh778IeF662MAp3ZWAVw0lQO4uTIPoHGq
	GIHLDgcJqx1lJKzvOg7bK0sI2L3kQmB7xTwOP/c2EHBO9xeHdpMGgaV9NgSWbR3g0PLEhEDX
	jBKDZc1dCLS8NqKwaWgahWtLtSg06OtQuFDlIuGkdoCEn/YtONzt/I7HhrC6ZzrANvZsALZH
	PUuyGr2cNbSFs03vVhBWr60gWP1mDckqXBMIuzY2RrLDT/cwdnFCibBNVbU4u+H8irHrfZME
	a9UMkfGBt3jRaeLMjDyxLCImmZc+Yt7HchaQB0s6BVEIWhAF8KMY+gLzsqSU8PExxjbX4WYe
	FUC3AOZ5rw73HSUIYx1VehN8OpzpnypHPYzRYYytp5T0MEELmQN1t7dJQCcxv7TbhM/vz+zW
	zmEKQFFBdCLzY/i+pxOlBynmo7Xe2xlIJzB2hxX1jdkQ5o3T6A37ucdeLDejnjDqHvg2Hu6R
	UfoUY9C50GpAqw9NqP+71IdcGoBqgUAsT83hUiTSKCEnknLyLIkwNVuqB77X2H4LWj5cNgOa
	AqFH+abVgcQAXJTH5UvNgKHQ0CD+nd9uiZ8myn8olmXflckzxZwZIJRfcCG4mduwIqy4EeME
	kqIuVU53R5Jpr9FZEH2FUhGzdwe4a1zx9Norwe32yBPRg4K4KTtSqYgVxsSejOO17iSkRFRl
	nJc9Mvo7VQatvEY5MtMpuRfluCRKDos/3T5mL79aLcaK6hbatiJhQREu7XauX/8Z3z9+JLVz
	ebvZ72KVKBTj0kWR4aiME/0DDB/8AfgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:46 AM, Sasha Levin wrote:
> Just to keep it going, here's a funny trace where kasan is catching issues
> in ubsan: :)
> 

Thanks, it turns out to be a GCC bug:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64741

As a workaround you could put kasan_disable_local()/kasan_enable_local()
into ubsan_prologue()/ubsan_epilogue().

