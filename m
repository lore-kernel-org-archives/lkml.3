Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaJUTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:18:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbaJUTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:18:40 -0400
Message-ID: <5446B178.3060300@oracle.com>
Date: Tue, 21 Oct 2014 15:18:16 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH 2/2] xen/pci: Use APIC directly when APIC
 virtualization is supported by hardware
References: <1413918075-26146-1-git-send-email-boris.ostrovsky@oracle.com> <1413918075-26146-3-git-send-email-boris.ostrovsky@oracle.com> <5446AF91.8070907@citrix.com>
In-Reply-To: <5446AF91.8070907@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/21/2014 03:10 PM, Andrew Cooper wrote:
> On 21/10/14 20:01, Boris Ostrovsky wrote:
>> diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
>> new file mode 100644
>> index 0000000..e57a457
>> --- /dev/null
>> +++ b/arch/x86/include/asm/xen/cpuid.h
>> @@ -0,0 +1,81 @@
>> +/******************************************************************************
>> + * arch-x86/cpuid.h
>> + *
>> + * CPUID interface to Xen.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a copy
>> + * of this software and associated documentation files (the "Software"), to
>> + * deal in the Software without restriction, including without limitation the
>> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
>> + * sell copies of the Software, and to permit persons to whom the Software is
>> + * furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>> + * DEALINGS IN THE SOFTWARE.
>> + *
>> + * Copyright (c) 2007 Citrix Systems, Inc.
>> + *
>> + * Authors:
>> + *    Keir Fraser <keir@xen.org>
>> + */
>> +
>> +#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__
>> +#define __XEN_PUBLIC_ARCH_X86_CPUID_H__
>> +
>> +/* Xen identification leaves start at 0x40000000. */
> On reading this, I notice that the Xen header files are wrong.  I will
> submit a correction.

You mean GPL part is missing?

I'll pick it up then when you are done since I need to resubmit this 
anyway --- I forgot to run checkpatch and there is a bunch of whitespace 
errors.

Thanks.
-boris

