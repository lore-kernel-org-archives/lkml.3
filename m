Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaLSNFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:05:00 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45642 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaLSNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:04:58 -0500
Message-ID: <5494226A.4040006@linaro.org>
Date: Fri, 19 Dec 2014 21:04:42 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Charles.Garcia-Tobin@arm.com" <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        "vanDoorn, Leendert" <Leendert.vanDoorn@amd.com>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>,
        "Duran, Leo" <leo.duran@amd.com>,
        "Gorishek, Frank" <Frank.Gorishek@amd.com>, Jeff.Underhill@arm.com
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org> <54933299.9030902@amd.com>
In-Reply-To: <54933299.9030902@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年12月19日 04:01, Suravee Suthikulanit wrote:
> On 10/17/2014 8:37 AM, Hanjun Guo wrote:
>
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> Add documentation for the guidelines of how to use ACPI
>> on ARM64.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   Documentation/arm64/arm-acpi.txt |  323
>> ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 323 insertions(+)
>>   create mode 100644 Documentation/arm64/arm-acpi.txt
>> [...]
>
> AMD has reviewed this document, and currently implements ACPI table in
> the firmware for AMD Seattle platform based on the documentation
> published here:
>
> http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/Seattle_ACPI_Guide.pdf
>
>
> Reviewed-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Thank you very much, Suravee.

Hanjun
