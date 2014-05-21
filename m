Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEUCGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:06:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:42261 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaEUCGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,877,1392192000"; 
   d="scan'208";a="535209351"
Message-ID: <537C0A12.70902@intel.com>
Date: Wed, 21 May 2014 10:06:10 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 1/5] ACPICA: Export acpi_buffer_to_resource symbol
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com> <1400590764-11108-2-git-send-email-tianyu.lan@intel.com> <1782070.yxHZNBOPJ3@vostro.rjw.lan>
In-Reply-To: <1782070.yxHZNBOPJ3@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年05月21日 05:24, Rafael J. Wysocki wrote:
> On Tuesday, May 20, 2014 08:59:20 PM Lan Tianyu wrote:
>> The acpi_buffer_to_resource is needed in i2c module
>> to convert aml buffer to struct acpi_resource
>>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> 
> This isn't necessary on top of current linux-next I believe?  If so,
> please do not resend it any more.

Yes, please ignore it and resending it is to facilitate some testers to
the patchset. Ok. I will not resend it.

> 
>> ---
>>  drivers/acpi/acpica/rscreate.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
>> index 75d3690..5828649 100644
>> --- a/drivers/acpi/acpica/rscreate.c
>> +++ b/drivers/acpi/acpica/rscreate.c
>> @@ -112,6 +112,7 @@ acpi_buffer_to_resource(u8 *aml_buffer,
>>  
>>  	return (status);
>>  }
>> +ACPI_EXPORT_SYMBOL(acpi_buffer_to_resource);
>>  
>>  /*******************************************************************************
>>   *
>>
> 


-- 
Best regards
Tianyu Lan
