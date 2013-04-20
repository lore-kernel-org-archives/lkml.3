Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3DTJWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 05:22:16 -0400
Received: from relay2.blacknight.com ([78.153.203.205]:40215 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3DTJWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 05:22:14 -0400
Message-ID: <51725ED4.8020001@nexus-software.ie>
Date: Sat, 20 Apr 2013 10:24:36 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419191128.GA21991@pd.tnic> <5171AA86.604@nexus-software.ie> <20130419205515.GA3075@pd.tnic> <20130419212514.GC3075@pd.tnic> <5171BAD6.4040003@nexus-software.ie> <5171CF86.30708@zytor.com>
In-Reply-To: <5171CF86.30708@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/13 00:13, H. Peter Anvin wrote:
> On 04/19/2013 02:44 PM, Bryan O'Donoghue wrote:
>> On 19/04/13 22:25, Borislav Petkov wrote:
>>> On Fri, Apr 19, 2013 at 10:55:15PM +0200, Borislav Petkov wrote:
>>>> Just filter out P5 and earlier. The code already does that for CPUs
>>>> which don't have CPUID.
>>>
>>> Actually, an alternative - more practical albeit not very accurate
>>
>> More practical ? Hmm - the MSRs don't exist for<  P5
>>
>>> solution would be to check for which families Intel delivers microcode
>>> and do the cut off there with a comment as to why you do it like
>>> that.void
>>
>> You mean return !intel so this function will never be called.
>>
>> __init load_ucode_bsp(void)
>> {
>>          int vendor = x86_vendor();
>>
>>          if (vendor == X86_VENDOR_INTEL)
>>                  load_ucode_intel_bsp();
>> }
>>
>> Ah yes. That would work and be less code.
>>
>> We should do it that way.
>
> Do you think you can have a patch for me in the next few hours?

Sure.

I'm in Ireland (sleeping @ 00:15 on a Friday night sadly).

Give me ~ 40 minutes

