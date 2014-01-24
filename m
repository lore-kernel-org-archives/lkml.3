Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaAXOn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:43:26 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56625 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaAXOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:43:24 -0500
Message-ID: <52E27C03.8090903@linaro.org>
Date: Fri, 24 Jan 2014 22:43:15 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 03/20] ARM64 / ACPI: Introduce the skeleton of _PDC related
 for ARM64
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-4-git-send-email-hanjun.guo@linaro.org> <52D93D4E.5020605@arm.com> <52DCEA66.90903@linaro.org> <20140123161918.GA25927@localhost>
In-Reply-To: <20140123161918.GA25927@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年01月24日 00:19, Catalin Marinas wrote:
> On Mon, Jan 20, 2014 at 09:20:38AM +0000, Hanjun Guo wrote:
>> On 2014-1-17 22:25, Sudeep Holla wrote:
>>> On 17/01/14 12:24, Hanjun Guo wrote:
>>>> --- a/arch/arm64/kernel/process.c
>>>> +++ b/arch/arm64/kernel/process.c
>>>> @@ -89,6 +89,9 @@ void arch_cpu_idle_prepare(void)
>>>>   	local_fiq_enable();
>>>>   }
>>>>   
>>>> +unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
>>>> +EXPORT_SYMBOL(boot_option_idle_override);
>>>> +
>>> This is what I mentioned in other email. Do we really foresee use of this in
>>> ARM64 or it's just added to avoid build issues ?
>> Just avoid build issues, can not foresee use of this in ARM64 :)
> So ideally we should look for a better solution here.

Ok, I will try my best.

Thanks
Hanjun
