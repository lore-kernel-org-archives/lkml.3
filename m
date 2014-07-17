Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaGQDTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:19:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56059 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaGQDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:19:09 -0400
Message-ID: <53C7406E.40902@linaro.org>
Date: Thu, 17 Jul 2014 11:18:06 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 1/3] ACPI: ARM64 does not have a BIOS add config for
 BIOS table scan.
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org> <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org> <53C70CCC.2080109@zytor.com> <3908561D78D1C84285E8C5FCA982C28F3285FB3C@ORSMSX114.amr.corp.intel.com> <53C70F78.40206@zytor.com>
In-Reply-To: <53C70F78.40206@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-17 7:49, H. Peter Anvin wrote:
> On 07/16/2014 04:46 PM, Luck, Tony wrote:
>>> +	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
>>
>>> This shouldn't actually be set on IA64, should it?  IA64 doesn't have
>>> BIOS, either, it has EFI/UEFI, like ARM64...

Yes, I agree with you, thanks for pointing this out. if I remember
correctly, the EFI standard was introduced when IA64 came out.

>>
>> Which ACPI tables are in the "LEGACY" category affected by this option?
>>
> 
> That's not what this is about... it is about how you find the root pointer.
> 
> On a BIOS system it is found by scanning low memory.  On an EFI system
> it is found by querying EFI for a specific UUID.

Thanks for the explanation.

Tony, if it is ok with you, I will modify the patch and will not select
ACPI_LEGACY_TABLES_LOOKUP on IA64, I'm waiting for your final confirmation.

Thanks
Hanjun
