Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaCKInT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:43:19 -0400
Received: from mailapp01.imgtec.com ([195.89.28.114]:34987 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:43:15 -0400
Message-ID: <531ECC9A.8000808@imgtec.com>
Date: Tue, 11 Mar 2014 08:43:06 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <dborkman@redhat.com>
Subject: Re: [PATCH v2] tools/net/Makefile: Define PACKAGE to fix build problems
References: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com> <20140310.215352.573291450790920864.davem@davemloft.net>
In-Reply-To: <20140310.215352.573291450790920864.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.136]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 01:53 AM, David Miller wrote:
> From: Markos Chandras <markos.chandras@imgtec.com>
> Date: Mon, 10 Mar 2014 10:39:48 +0000
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
>> Acked-by: Daniel Borkmann <dborkman@redhat.com>
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>
> Please submit networking patches with netdev@vger.kernel.org at least
> CC:'d so that such patches can be properly tracked in patchwork.
>
> Thank you.
>
Hi David,

Apologies. When I ran the scripts/get_maintainer.pl on my patch, 
netdev@vger.kernel.org was not listed there. I will send it again.

-- 
markos
