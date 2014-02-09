Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBIJGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:06:13 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39588 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBIJGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:06:08 -0500
Message-ID: <52F744F9.5090001@linaro.org>
Date: Sun, 09 Feb 2014 17:06:01 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/2] ACPI / processor: Replace hard-coded "ACPI0007" with
 ACPI_PROCESSOR_DEVICE_HID
References: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org> <3206968.bZnklzZdTg@vostro.rjw.lan>
In-Reply-To: <3206968.bZnklzZdTg@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年02月08日 23:03, Rafael J. Wysocki wrote:
> On Saturday, February 08, 2014 08:46:25 PM Hanjun Guo wrote:
>> Replace "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID to improve code
>> readability.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   drivers/acpi/processor_core.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
>> index a4eea9a..849cfd6 100644
>> --- a/drivers/acpi/processor_core.c
>> +++ b/drivers/acpi/processor_core.c
>> @@ -390,5 +390,6 @@ void __init acpi_early_processor_set_pdc(void)
>>   	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>>   			    ACPI_UINT32_MAX,
>>   			    early_init_pdc, NULL, NULL, NULL);
>> -	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
>> +	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID,
>> +				early_init_pdc, NULL, NULL);
> Please don't break this line (I know it will exceed 80 characters).

Ok, I will update this patch.

Thanks
Hanjun

