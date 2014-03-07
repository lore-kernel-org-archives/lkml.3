Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaCGJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:18:36 -0500
Received: from mailapp01.imgtec.com ([195.89.28.114]:41386 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaCGJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:18:29 -0500
Message-ID: <53198EE4.8030103@imgtec.com>
Date: Fri, 7 Mar 2014 09:18:28 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <dborkman@redhat.com>
Subject: Re: [PATCH] tools/net/Makefile: Define PACKAGE to fix bfd build problems
References: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com> <20140306.125412.1583267049751920093.davem@davemloft.net>
In-Reply-To: <20140306.125412.1583267049751920093.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:54 PM, David Miller wrote:
> From: Markos Chandras <markos.chandras@imgtec.com>
> Date: Thu, 6 Mar 2014 09:15:54 +0000
>
>> Fixes the following build problem with binutils-2.24
>>
>> gcc -Wall -O2   -c -o bpf_jit_disasm.o bpf_jit_disasm.c
>> In file included from bpf_jit_disasm.c:25:0:
>> /usr/include/bfd.h:35:2: error: #error config.h must be included
>> before this header
>>   #error config.h must be included before this header
>>
>> This is similar to commit 3ce711a6abc27abce1554e1d671a8762b7187690
>> "perf tools: bfd.h/libbfd detection fails with recent binutils"
>>
>> See: https://sourceware.org/bugzilla/show_bug.cgi?id=14243
>>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Daniel Borkmann <dborkman@redhat.com>
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>
> I think your subject needs to be adjusted, this patch doesn't fix a "bfd"
> build problem.
>
Hi David,

Thanks for the comment. Well it's problem caused by the bfd header. 
However, I suppose you can remove the 'bfd' word from the subject as I 
understand it's confusing. Would you be able to fix this before you 
apply this patch or should I send a new patch?

-- 
markos
