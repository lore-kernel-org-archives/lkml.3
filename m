Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHTD1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:27:36 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64922 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaHTD1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:27:35 -0400
Message-ID: <53F41543.4090602@linaro.org>
Date: Wed, 20 Aug 2014 11:25:55 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geoff Levand <geoff@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, Charles.Garcia-Tobin@arm.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 08/18] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>		 <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org>	 <1408388212.22761.100.camel@smoke> <53F33EDC.3090203@linaro.org> <1408476326.22761.134.camel@smoke>
In-Reply-To: <1408476326.22761.134.camel@smoke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-20 3:25, Geoff Levand wrote:
> Hi Hanjun,
> 
> On Tue, 2014-08-19 at 20:11 +0800, Hanjun Guo wrote:
>> On 2014-8-19 2:56, Geoff Levand wrote:
> 
>>> 	message = acpi_disabled ? dn->full_name : "";
>>>
>>> 	...
>>> 	
>>> 	pr_warn("CPU %d: %s unsupported enable-method property: %s\n",
>>> 				cpu, message, enable_method)
>>
>> In ACPI, there is no enable-method property, it is a term from, so I think the
>> message printed can be separated.
> 
> I think it better to have a single message that can cover all
> than to have separate messages.  Wouldn't the enable method be
> "acpi-parking" or "acpi-psci"?  Then something like this would
> work:
> 
> 	pr_warn("CPU %d: %s Unsupported enable method: %s\n", cpu, message, enable_method);

Thanks for the suggestion, I will update it in next version.

Thanks
Hanjun

