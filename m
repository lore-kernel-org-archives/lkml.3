Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaHEDgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:36:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64769 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaHEDfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:35:32 -0400
Message-ID: <53E050B2.2080609@linaro.org>
Date: Tue, 05 Aug 2014 11:34:10 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v2 00/18] Introduce ACPI for ARM64 based
 on ACPI 5.1
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <CAJRNFK+UfJhGR65tOecy=X+YdHQHiNPZ4p_p8LUxhRL3GW5gFw@mail.gmail.com>
In-Reply-To: <CAJRNFK+UfJhGR65tOecy=X+YdHQHiNPZ4p_p8LUxhRL3GW5gFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-5 1:30, Alexander Spyridakis wrote:
> On 4 August 2014 17:28, Hanjun Guo <hanjun.guo@linaro.org
> <mailto:hanjun.guo@linaro.org>> wrote:
>>
>> ACPI 5.1 has been released and now be freely available for
>> download [1]. It fixed some major gaps to run ACPI on ARM,
>> this patch just follow the ACPI 5.1 spec and prepare the
>> code to run ACPI on ARM64.
> 
> Hello,

Hi,

> 
> Is this work still reproducible on Foundation and/or ARMv8 FVP models, as
> described in the following wiki page?
> https://wiki.linaro.org/LEG/Engineering/Kernel/ACPI

Yes, I think so. If you meet any problem , please let us know, and we will
update the wiki.

> 
> Should I assume that UEFI is mandatory (alternative being the aarch64
> bootwrapper), as described in Documentation/arm64/arm-acpi.txt?

Yes, UEFI is mandatory if you want to use ACPI.

> 
> Thanks in advance.

You are welcome :)

Thanks
Hanjun

