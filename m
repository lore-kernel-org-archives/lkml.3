Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBDCPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:15:23 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34445 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaBDCPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:15:18 -0500
Message-ID: <52F04D33.5080208@linaro.org>
Date: Mon, 03 Feb 2014 21:15:15 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH v5 16/16] ARM: Remove uprobes dependency on kprobes
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>  <1390507559-4697-17-git-send-email-dave.long@linaro.org> <1391442358.3509.19.camel@linaro1.home>
In-Reply-To: <1391442358.3509.19.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/14 10:45, Jon Medhurst (Tixy) wrote:
> On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Now that arm uprobes support has been made separate from the arm kprobes code
>> the Kconfig can be changed to reflect that.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm/Kconfig | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index fec5a6b..9ddc4ae 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -204,7 +204,6 @@ config NEED_DMA_MAP_STATE
>>          def_bool y
>>
>>   config ARCH_SUPPORTS_UPROBES
>> -	depends on KPROBES
>>   	def_bool y
>>
>>   config ARCH_HAS_DMA_SET_COHERENT_MASK
>
>
> Was this patch meant to have other contents? If not, it seems a bit
> pointless as all it does is remove a line added in the previous patch,
> so should just be folded into that one.
>

That patch was added late to a much earlier rev.  It should have been 
merged with the previous patch before now.  I have just done so.

-dl

