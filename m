Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3KZKQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:16:51 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39070 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab3KZKQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:16:46 -0500
Message-ID: <529474C7.9050005@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 15:45:35 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "mpe@ellerman.id.au" <michael@ozlabs.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com, eranian@google.com, michaele@au1.ibm.com
Subject: Re: [V3 01/10] perf: New conditional branch filter criteria in branch
 stack sampling
References: <20131126060618.917ED2C00A9@ozlabs.org>
In-Reply-To: <20131126060618.917ED2C00A9@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112610-8878-0000-0000-000009D56E12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 11:36 AM, mpe@ellerman.id.au wrote:
> Ideally your commit subject would contain a verb, preferably in the present
> tense.
> 
> I think simply "perf: Add PERF_SAMPLE_BRANCH_COND" would be clearer.


Sure, will change it.

> 
> On Wed, 2013-16-10 at 06:56:48 UTC, Anshuman Khandual wrote:
>> POWER8 PMU based BHRB supports filtering for conditional branches.
>> This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
>> will extend the existing perf ABI. Other architectures can provide
>> this functionality with either HW filtering support (if present) or
>> with SW filtering of instructions.
>>
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> Reviewed-by: Stephane Eranian <eranian@google.com>
>> ---
>>  include/uapi/linux/perf_event.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 0b1df41..5da52b6 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
>>  	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
>>  	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
>>  	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
>> +	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
>>  
>> -	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
>> +	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
>>  };
> 
> This no longer applies against Linus' tree, you'll need to rebase it.

Okay

