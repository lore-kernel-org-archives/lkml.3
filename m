Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaHEDiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:38:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43447 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbaHEDh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:37:26 -0400
Message-ID: <53E05125.1030007@linaro.org>
Date: Tue, 05 Aug 2014 11:36:05 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
CC: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 18/18] Documentation: ACPI for ARM64
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-19-git-send-email-hanjun.guo@linaro.org> <53DFF18B.5080509@infradead.org>
In-Reply-To: <53DFF18B.5080509@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-5 4:48, Randy Dunlap wrote:
> On 08/04/14 08:28, Hanjun Guo wrote:
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> Add documentation for the guidelines of how to use ACPI
>> on ARM64.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  Documentation/arm64/arm-acpi.txt |  215 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 215 insertions(+)
>>  create mode 100644 Documentation/arm64/arm-acpi.txt
>>
>> diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
>> new file mode 100644
>> index 0000000..a6e14a2
>> --- /dev/null
>> +++ b/Documentation/arm64/arm-acpi.txt
>> @@ -0,0 +1,215 @@
>> +ACPI on ARMv8 Servers
>> +---------------------
>> +
> 
> ...
> 
>> +
>> +ACPI Detection
>> +--------------
>> +
>> +Drivers should determine their probe() type by checking for ACPI_HANDLE,
>> +or .of_node, or other information in the device structure. This is
>> +detailed further in the "Driver Recommendations" section.
>> +
>> +In non-driver code If the presence of ACPI needs to be detected at runtime,
>> +then check the value of acpi_disabled. If CONFIG_ACPI not being set,
> 
>                                           If CONFIG_ACPI is not set,

Good catch, We will update it.

Thanks
Hanjun

