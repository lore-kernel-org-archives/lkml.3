Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaGPXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:49:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47143 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbaGPXtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:49:52 -0400
Message-ID: <53C70F78.40206@zytor.com>
Date: Wed, 16 Jul 2014 16:49:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Hanjun Guo <hanjun.guo@linaro.org>,
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
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org> <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org> <53C70CCC.2080109@zytor.com> <3908561D78D1C84285E8C5FCA982C28F3285FB3C@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3285FB3C@ORSMSX114.amr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 04:46 PM, Luck, Tony wrote:
>> +	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
> 
>> This shouldn't actually be set on IA64, should it?  IA64 doesn't have
>> BIOS, either, it has EFI/UEFI, like ARM64...
> 
> Which ACPI tables are in the "LEGACY" category affected by this option?
> 

That's not what this is about... it is about how you find the root pointer.

On a BIOS system it is found by scanning low memory.  On an EFI system
it is found by querying EFI for a specific UUID.

	-hpa



