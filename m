Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbbAFLWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:22:24 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52261 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbbAFLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:22:22 -0500
Message-ID: <54ABC551.3080005@linaro.org>
Date: Tue, 06 Jan 2015 19:21:53 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: liyi 00215672 <phoenix.liyi@huawei.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        "Charles.Garcia-Tobin@arm.com" <Charles.Garcia-Tobin@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: =?gbk?Q?=B4=F0=B8=B4=3A_=5BPATCH_v6_17/17=5D_Documen?=
 =?gbk?Q?tation=3A_ACPI_for_ARM64?=
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org> <1420368918-5086-18-git-send-email-hanjun.guo@linaro.org> <D0F5605BA99F0B4594FB1EEC24E785CC654879C3@SZXEMA510-MBX.china.huawei.com>
In-Reply-To: <D0F5605BA99F0B4594FB1EEC24E785CC654879C3@SZXEMA510-MBX.china.huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yi,

On 2015Äê01ÔÂ06ÈÕ 17:52, liyi 00215672 wrote:
> In traditional telecom market, what confused us(Huawei) was our software and
> hardware coupling together oftentimes. So if we change some hardware then we
> MUST modify our software, which was not our customer¡¯s expectation. In x86 world,
> we have UEFI and ACPI technologies, they are suitable to solve this problem very
> well, we just upgrade our hardware and don¡¯t need to upgrade their software,
> in the meantime ACPI provides many methods on power management.
>
> In ARM64 world, we are aiming the same thing. Following the SBBR,SBSA specs
> to implement our UEFI and ACPI code, we think the patch set and arm-acpi
> documentation are fine , and consider it is going on the right direction, so
>
> Reviewed-by: Yi Li <phoenix.liyi@huawei.com>

Thanks a lot!

Regards,
Hanjun
