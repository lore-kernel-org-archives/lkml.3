Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaCDC2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:28:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaCDC2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:28:35 -0500
Message-ID: <53153A4C.9050602@infradead.org>
Date: Mon, 03 Mar 2014 18:28:28 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Graeme Gregory <graeme.gregory@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        grant.likely@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com,
        lenb@kernel.org, rjw@rjwysocki.net
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>	 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org> <1393899715.20435.8.camel@joe-AO722>
In-Reply-To: <1393899715.20435.8.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 06:21 PM, Joe Perches wrote:
> On Tue, 2014-03-04 at 10:15 +0800, Graeme Gregory wrote:
>> Add maintainers for the arm-core file for arm64 ACPI support
> 
> Shouldn't something have to be in the kernel
> tree before there's a MAINTAINERS entry?

or in linux-next and the patch can be added to linux-next (some git tree).

>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c6d0e93..c770d3a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -259,6 +259,13 @@ F:	drivers/pci/*/*acpi*
>>  F:	drivers/pci/*/*/*acpi*
>>  F:	tools/power/acpi
>>  
>> +ACPI ARM64
>> +M:	Hanjun Guo <hanjun.guo@linaro.org>
>> +M:	Graeme Gregory <graeme.gregory@linaro.org>
>> +S:	Supported
>> +L:	linux-acpi@vger.kernel.org
>> +F:	drivers/acpi/plat/arm-core.c
>> +
>>  ACPI COMPONENT ARCHITECTURE (ACPICA)
>>  M:	Robert Moore <robert.moore@intel.com>
>>  M:	Lv Zheng <lv.zheng@intel.com>


-- 
~Randy
