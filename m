Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbbAFLRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:17:53 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54445 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbbAFLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:17:51 -0500
Message-ID: <54ABC443.2070502@linaro.org>
Date: Tue, 06 Jan 2015 19:17:23 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v6 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org> <54AB894C.9010001@huawei.com>
In-Reply-To: <54AB894C.9010001@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月06日 15:05, Yijing Wang wrote:
> On 2015/1/4 18:55, Hanjun Guo wrote:
>> Hi,
>
> Hello Hanjun,
>
> We tested your v5 patch set (and added some GICv3 patches) on Hisilicon ARM64 SoC hardware,
> from your change log for v6,  there is only one functional change to fix the NULL pointer, I think
> the test result is still valid for v6, please refer to the test result below [1].
>
> We can boot the system successfully using PSCI on our ARM64 hardware using this patch set, of course
> we need to add some more patches (GICv3), but with this patch set:
>
> You could add my Tested-by: Yijing Wang <wangyijing@huawei.com> if you want.

Great, thanks a lot!

>
> if you want me to test the new version of patch set, please let me know, thanks.

if you have some free time, please help me to do that :)

Thanks
Hanjun
