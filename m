Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaHSIkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:40:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60083 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaHSIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:40:05 -0400
Message-ID: <53F30D02.1040306@linaro.org>
Date: Tue, 19 Aug 2014 16:38:26 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v2 17/18] ARM64 / ACPI: Enable ARM64 in Kconfig
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-18-git-send-email-hanjun.guo@linaro.org> <20140818142745.GV20043@localhost>
In-Reply-To: <20140818142745.GV20043@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-18 22:27, Catalin Marinas wrote:
> On Mon, Aug 04, 2014 at 04:28:24PM +0100, Hanjun Guo wrote:
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index 3f5f745..f6b6791 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -5,8 +5,7 @@
>>  menuconfig ACPI
>>  	bool "ACPI (Advanced Configuration and Power Interface) Support"
>>  	depends on !IA64_HP_SIM
>> -	depends on IA64 || X86
>> -	depends on PCI
>> +	depends on ((IA64 || X86) && PCI) || ARM64
> 
> depends on (ARM64 && EXPERT)? (together with default on if CONFIG_ACPI
> is enabled).

I will update that in next version.

Thanks for all your comments!

Hanjun

