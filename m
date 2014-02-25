Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBYVOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:14:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43388 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaBYVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:14:18 -0500
Message-ID: <530D0796.6020704@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 13:13:58 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 04/11] powerpc: add hvcalls for 24x7 and gpci (get
 performance counter info)
References: <20140225033327.878F52C0256@ozlabs.org>
In-Reply-To: <20140225033327.878F52C0256@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022521-8236-0000-0000-0000002A8D26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:33 PM, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:08 UTC, Cody P Schafer wrote:
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/include/asm/hvcall.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
>> index d8b600b..652f7e4 100644
>> --- a/arch/powerpc/include/asm/hvcall.h
>> +++ b/arch/powerpc/include/asm/hvcall.h
>> @@ -274,6 +274,11 @@
>>   /* Platform specific hcalls, used by KVM */
>>   #define H_RTAS			0xf000
>>
>> +/* "Platform specific hcalls", provided by PHYP */
>> +#define H_GET_24X7_CATALOG_PAGE 0xF078
>> +#define H_GET_24X7_DATA		0xF07C
>> +#define H_GET_PERF_COUNTER_INFO 0xF080
>
> Some tabs some spaces, use tabs.

Ack.

