Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaKQCdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:33:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55758 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaKQCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:33:09 -0500
Message-ID: <54695DE5.2080309@linaro.org>
Date: Mon, 17 Nov 2014 10:31:01 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 3/3] ACPI / processor: Rename acpi_(un)map_lsapic() to
 acpi_(un)map_cpu()
References: <1414662780-2147-1-git-send-email-hanjun.guo@linaro.org> <5452CE9D.6000403@linaro.org> <10283319.F5QMI6fbWn@vostro.rjw.lan> <1820875.eppNBckBcQ@vostro.rjw.lan>
In-Reply-To: <1820875.eppNBckBcQ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-15 7:35, Rafael J. Wysocki wrote:
> On Friday, October 31, 2014 11:55:46 PM Rafael J. Wysocki wrote:
>> On Friday, October 31, 2014 07:49:49 AM Hanjun Guo wrote:
>>> On 2014年10月31日 04:12, Rafael J. Wysocki wrote:
>>>> On Thursday, October 30, 2014 05:53:00 PM Hanjun Guo wrote:
>>>>> acpi_map_lsapic() will allocate a logical CPU number and map it to
>>>>> physical CPU id (such as APIC id) for the hot-added CPU, it will also
>>>>> do some mapping for NUMA node id and etc, acpi_unmap_lsapic() will
>>>>> do the reverse.
>>>>>
>>>>> We can see that the name of the function is a little bit confusing and
>>>>> arch dependent so rename them as acpi_(un)map_map() to make arch
>>>>
>>>> That's acpi_(un)map_cpu() I guess?
>>>
>>> ah, yes, typos, it should be acpi_(un)map_cpu(), my fault.
>>> should I send another version?
>>
>> No, I can fix this up.
> 
> I've queued up the series for 3.19, thanks!

Thanks!

Hanjun

