Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaCCBtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:49:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:57447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaCCBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,574,1389772800"; 
   d="scan'208";a="492576618"
Message-ID: <5313DF9A.7000204@linux.intel.com>
Date: Mon, 03 Mar 2014 09:49:14 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com> <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com> <5313AD1B.6050403@linux.intel.com> <20140302222654.GA17838@srcf.ucam.org> <5313B47B.6020402@linux.intel.com> <20140302231154.GA20891@srcf.ucam.org> <5313BD5A.1040409@linux.intel.com> <20140303000759.GA25085@srcf.ucam.org> <5313CA6B.7020505@zytor.com> <5313DC82.7030802@linux.intel.com> <51d8c7f9-656d-48ad-8b82-0e4302c4b827@email.android.com>
In-Reply-To: <51d8c7f9-656d-48ad-8b82-0e4302c4b827@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/3 9:47, H. Peter Anvin wrote:
> We are not removing BOOT_BIOS... whether or not we have it on buy default is another matter.

Right, I meant I remove BOOT_BIOS from my second patch if needed.

Thanks,
-Aubrey

> 
> On March 2, 2014 5:36:02 PM PST, "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
>> On 2014/3/3 8:18, H. Peter Anvin wrote:
>>> On 03/02/2014 04:07 PM, Matthew Garrett wrote:
>>>> On Mon, Mar 03, 2014 at 07:23:06AM +0800, Li, Aubrey wrote:
>>>>
>>>>> Windows doesn't do because there is no 32/64 mixed windows and EFI
>> on
>>>>> the planet. Since the silicon is actually 64 bit, I failed to see a
>>>>> reason to refuse the user install 64bit linux on it. So we
>> encountered a
>>>>> case windows didn't.
>>>>
>>>> And we'll call the 32 bit EFI call, so what's the problem?
>>
>> No problem after Fleming's mixed mode is landed.
>>
>>>>
>>>>> So, you didn't mention BOOT_BIOS, if you don't want to add
>> BOOT_BIOS,
>>>>> and you also don't like DMI entires, how do you want to deal with
>> the
>>>>> machines requiring BOOT_BIOS to reboot their machine?
>>>>
>>>> I was planning on ignoring them.
>>>>
>>
>> Well, I'm fine to ignore BOOT_BIOS because I don't have one in hand,
>> but
>> I'll bother you again with the same logic when I have one, heihei.
>> Do you need me to refine the patch to remove BOOT_BIOS?
>>
>>>
>>> I suspect we'll never get away from having a DMI table, if nothing
>> else
>>> because we can't test enough, but the current situation where it
>> seems
>>> like we need to add every since Dell box to the DMI table is clearly
>> broken.
>>>
>>> 	-hpa
>>>
>> Agree, definitely.
>>
>> Thanks,
>> -Aubrey
> 

