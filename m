Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaFQCCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:02:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49341 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaFQCCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:02:18 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539FA1A1.6030502@roeck-us.net>
Date: Mon, 16 Jun 2014 19:02:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] powerpc: Fix build warning
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net> <alpine.DEB.2.02.1406161824340.21018@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406161824340.21018@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 06:25 PM, David Rientjes wrote:
> On Fri, 13 Jun 2014, Guenter Roeck wrote:
>
>> If compiled with W=1, the following warning is seen in powerpc builds.
>>
>> arch/powerpc/kernel/smp.c:750:18: warning:
>> 	type qualifiers ignored on function return type
>> static const int powerpc_smt_flags(void)
>>                   ^
>>
>> This is caused by a function returning 'const int', which doesn't
>> make sense to gcc. Drop 'const' to fix the problem.
>>
>> Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> Acked-by: David Rientjes <rientjes@google.com>
>
> Although it's strange you report this happening on line 750 in the
> changelog but the patch shows it differently.
>

In the latest kernel (v3.16-rc1) the function is at line 750.
It appears that I ran the build test on a later version than
the one I used to write the patch. Hope that is not a problem.

Guenter

