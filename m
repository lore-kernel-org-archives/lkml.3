Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaGQERt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:17:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62412 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaGQERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:17:46 -0400
Message-ID: <53C74E67.9050401@converseincode.com>
Date: Wed, 16 Jul 2014 21:17:43 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: anurag19aggarwal@gmail.com, catalin.marinas@arm.com, charlebm@gmail.com,
        dave.long@linaro.org, k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, dwmw2@infradead.org
Subject: Re: [PATCH 0/6] LLVMLinux: Patches to enable the kernel to be compiled
 with clang/LLVM
References: <1404850576-2006-1-git-send-email-behanw@converseincode.com> <alpine.LFD.2.11.1407130508580.3647@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1407130508580.3647@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/14 02:10, Nicolas Pitre wrote:
> On Tue, 8 Jul 2014, behanw@converseincode.com wrote:
>
>> From: Behan Webster <behanw@converseincode.com>
>>
>> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
>> clang (the C front end for the LLVM compiler infrastructure project).
>>
>> Clang only supports global named registers for non-allocatable registers like
>> the stack pointer. By centralizing the definition of current_stack_pointer, the
>> use of named registers for ARM remains largely unchanged while working for both
>> gcc and clang.
> You verified that the compiled code is identical on gcc?
Yes. Identical.

>    If so:
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

