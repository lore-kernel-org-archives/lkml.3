Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3HBVGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:06:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55146 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3HBVGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:06:49 -0400
Message-ID: <51FC1F3A.8090201@ti.com>
Date: Fri, 2 Aug 2013 17:06:02 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
References: <20130629152959.GB31339@mtj.dyndns.org> <20130629172123.GA3353@n2100.arm.linux.org.uk> <20130629175743.GA382@mtj.dyndns.org> <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com> <20130629195549.GE3353@n2100.arm.linux.org.uk> <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com> <51D18DBA.6090608@ti.com> <51F1A7AA.8080700@ti.com> <20130725223658.GJ26107@mtj.dyndns.org> <51F1B17F.30902@ti.com> <20130726030812.GB30195@mtj.dyndns.org>
In-Reply-To: <20130726030812.GB30195@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Thursday 25 July 2013 11:08 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 25, 2013 at 07:15:11PM -0400, Santosh Shilimkar wrote:
>> Sorry if I wasn't clear before, but I need help to at least have new
>> memblock API support since I am not familiar with memblock code. 
>> I could help in adaptation to the new API for ARM arch and
>> core kernel code.
>>
>> Let me know your thoughts.
> 
> Unfortunately, I'm currently a bit too occupied to work on it myself.
> Any volunteers?
> 
Looking at the situation, how about proceeding with patch updating
the bootmem API signatures to use phys_addr_t  which can unblock me
to get my machine working.

Introduction of new API, conversions of core kernel code and then
arches moving away from bootmem is going to take significant time
anyways. I will continue my effort to get ARM port moved to no-bootmem
and get that merged.

Let me know how to make progress here. Appreciate your help on the subject.

Regards,
Santosh

