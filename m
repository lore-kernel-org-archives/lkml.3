Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaDHMVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:21:35 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41104 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbaDHMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:21:33 -0400
Message-ID: <5343E9BE.7030608@linaro.org>
Date: Tue, 08 Apr 2014 20:21:18 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Grant Likely <grant.likely@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH V2] ACPI: Update the ownership and developers for ACPI
 in Kconfig
References: <1396956241-8337-1-git-send-email-hanjun.guo@linaro.org> <3442476.Y3PYFAt6A7@vostro.rjw.lan>
In-Reply-To: <3442476.Y3PYFAt6A7@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 2014-4-8 20:01, Rafael J. Wysocki wrote:
> On Tuesday, April 08, 2014 07:24:01 PM Hanjun Guo wrote:
>> The UEFI Forum included the ACPI spec in its portfolio in October 2013
>> and will host future spec iterations, following the ACPI v5.0a release.
>>
>> A UEFI Forum working group named ACPI Specification Working Group (ASWG)
>> has been established to handle future ACPI developments, any UEFI member
>> can join the group and contribute to ACPI specification.
>>
>> So update the ownership and developers for ACPI in Kconfig accordingly,
>> and add another website link to ACPI specification too.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  drivers/acpi/Kconfig |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index c205653..6bbf36e 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -32,9 +32,11 @@ menuconfig ACPI
>>  	  <http://acpica.org/>
>>  
>>  	  ACPI is an open industry specification co-developed by
>> -	  Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba.
>> +	  ACPI Specification Working Group (ASWG) under UEFI Forum, any
>> +	  UEFI member can join ASWG and contribute to ACPI specification.
> 
> Thinking a bit more about that, I'd prefer this wording:
> 
> 	ACPI is an open industry specification originally co-developed by
> 	Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba.  Currently,
> 	it is developed by the ACPI Specification Working Group (ASWG) under
> 	the UEFI Forum and any UEFI member can join the ASWG and contribute
> 	to the ACPI specification.

Great, I like your wording very much, will sent another version shortly :)

Thanks
Hanjun

