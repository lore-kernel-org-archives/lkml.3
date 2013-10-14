Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3JNPZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:25:21 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46589 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3JNPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:25:19 -0400
Message-ID: <525C0CC2.7080305@gmail.com>
Date: Mon, 14 Oct 2013 23:24:50 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] Optimize jump label implementation on ARM64
References: <1381675827-1610-1-git-send-email-liuj97@gmail.com> <20131014151938.GJ10491@mudshark.cambridge.arm.com>
In-Reply-To: <20131014151938.GJ10491@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 11:19 PM, Will Deacon wrote:
> On Sun, Oct 13, 2013 at 03:50:20PM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> This patchset tries to optimize arch specfic jump label implementation
>> for ARM64 by dynamic kernel text patching.
>>
>> To enable this feature, your toolchain must support "asm goto" extension
>> and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
>> "%c", so you need a GCC patch similiar to this:
>> http://gcc.gnu.org/viewcvs/gcc/trunk/gcc/config/arm/arm.c?view=patch&r1=175293&r2=175565&pathrev=175565
>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
> 
> Right, but this is just for the ARM (AArch32) backend afaict. Are there any
> plans for upstream GCC to support this constraint for AArch64?
> 
> Will
> 
Hi Will,
	We have an internal GCC version with this issue fixed. But I'm not
familiar with GCC community and don't know the way to get the fix merged
into GCC mainstream. Any suggestion?
Thanks!

