Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbbA1Un3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:43:29 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59238 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbbA1UnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:43:24 -0500
Message-ID: <54C8E9C3.9010508@linaro.org>
Date: Wed, 28 Jan 2015 21:53:07 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>,
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
        phoenix.liyi@huawei.com, suravee.suthikulpanit@amd.com,
        wangyijing@huawei.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, ashwin.chaugule@linaro.org,
        msalter@redhat.com
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <54C7CF0D.4050607@codeaurora.org>
In-Reply-To: <54C7CF0D.4050607@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月28日 01:46, Timur Tabi wrote:
> On 01/14/2015 09:04 AM, Hanjun Guo wrote:
>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>
>
> Tested-by: Timur Tabi <timur@codeaurora.org>

Thanks!

>
> However, these 17 patches are insufficient to make ACPI work completely
> on ARM64.  I need to add two patches:
>
> acpi: add arm to the platforms that use ioremap
> http://lists.linaro.org/pipermail/linaro-acpi/2014-November/002943.html
>
> acpi: fix acpi_os_ioremap for arm64
> http://lists.linaro.org/pipermail/linaro-acpi/2014-November/002859.html
>
> Without these two patches, my ACPI-based device drivers don't probe. Can
> we add them to this 17-patch patchset?

I will add them into next version :)

Best Regards,
Hanjun
