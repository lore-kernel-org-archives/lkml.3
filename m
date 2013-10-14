Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3JNNta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:49:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47658 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3JNNt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:49:29 -0400
Message-ID: <525BF641.3000300@ti.com>
Date: Mon, 14 Oct 2013 09:48:49 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <yinghai@kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 06/23] mm/memblock: Add memblock early memory allocation
 apis
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com> <1381615146-20342-7-git-send-email-santosh.shilimkar@ti.com> <20131013175648.GC5253@mtj.dyndns.org> <20131013180058.GG25034@n2100.arm.linux.org.uk> <20131013184212.GA18075@htj.dyndns.org>
In-Reply-To: <20131013184212.GA18075@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 October 2013 02:42 PM, Tejun Heo wrote:
> On Sun, Oct 13, 2013 at 07:00:59PM +0100, Russell King - ARM Linux wrote:
>> On Sun, Oct 13, 2013 at 01:56:48PM -0400, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Sat, Oct 12, 2013 at 05:58:49PM -0400, Santosh Shilimkar wrote:
>>>> Introduce memblock early memory allocation APIs which allow to support
>>>> LPAE extension on 32 bits archs. More over, this is the next step
>>>
>>> LPAE isn't something people outside arm circle would understand.
>>> Let's stick to highmem.
>>
>> LPAE != highmem.  Two totally different things, unless you believe
>> system memory always starts at physical address zero, which is very
>> far from the case on the majority of ARM platforms.
>>
thanks Russell for clarification.

>> So replacing LPAE with "highmem" is pure misrepresentation and is
>> inaccurate.  PAE might be a better term, and is also the x86 term
>> for this.
> 
> Ah, right, forgot about the base address.  Let's please spell out the
> requirements then.  Briefly explaining both aspects (non-zero base
> addr & highmem) and why the existing bootmem based interfaced can't
> serve them would be helpful to later readers.
> 
OK. Will try to describe bit more in the next version.Cover letter had
some of the information on the requirement which I will also
mention in the patch commit in next version.

Regards,
Santosh
