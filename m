Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbaJ3XuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:50:00 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46086 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJ3Xt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:49:59 -0400
Message-ID: <5452CE9D.6000403@linaro.org>
Date: Fri, 31 Oct 2014 07:49:49 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
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
References: <1414662780-2147-1-git-send-email-hanjun.guo@linaro.org> <1414662780-2147-3-git-send-email-hanjun.guo@linaro.org> <2516177.7dftOY8x88@vostro.rjw.lan>
In-Reply-To: <2516177.7dftOY8x88@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年10月31日 04:12, Rafael J. Wysocki wrote:
> On Thursday, October 30, 2014 05:53:00 PM Hanjun Guo wrote:
>> acpi_map_lsapic() will allocate a logical CPU number and map it to
>> physical CPU id (such as APIC id) for the hot-added CPU, it will also
>> do some mapping for NUMA node id and etc, acpi_unmap_lsapic() will
>> do the reverse.
>>
>> We can see that the name of the function is a little bit confusing and
>> arch dependent so rename them as acpi_(un)map_map() to make arch
>
> That's acpi_(un)map_cpu() I guess?

ah, yes, typos, it should be acpi_(un)map_cpu(), my fault.
should I send another version?

Thanks
Hanjun
