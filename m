Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaIOW4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:56:05 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60545 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaIOW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:56:01 -0400
Message-ID: <54176E75.1000803@linaro.org>
Date: Tue, 16 Sep 2014 06:55:49 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 06/18] ARM64 / ACPI: Introduce early_param for "acpi"
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-7-git-send-email-hanjun.guo@linaro.org> <20140915062824.GB26649@localhost>
In-Reply-To: <20140915062824.GB26649@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月15日 14:28, Olof Johansson wrote:
> On Fri, Sep 12, 2014 at 10:00:04PM +0800, Hanjun Guo wrote:
>> From: Al Stone <al.stone@linaro.org>
>>
>> Introduce one early parameters "off" for "acpi" to disable ACPI on
>> ARM64.
>>
>> This ensures the kernel uses the DT on a platform that provides both
>> ACPI tables and DT.
>>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  Documentation/kernel-parameters.txt |    3 ++-
>>  arch/arm64/kernel/acpi.c            |   15 +++++++++++++++
>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 5ae8608..9dfb1d8 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -165,7 +165,7 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
>>  bytes respectively. Such letter suffixes can also be entirely omitted.
>>  
>>  
>> -	acpi=		[HW,ACPI,X86]
>> +	acpi=		[HW,ACPI,X86,ARM]
> ARM64, not ARM.

I will update it.

Thanks
Hanjun
