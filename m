Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3CHJAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:00:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab3CHJAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:00:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,807,1355068800"; 
   d="scan'208";a="6836782"
Message-ID: <5139A494.2050500@cn.fujitsu.com>
Date: Fri, 08 Mar 2013 16:43:00 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>
CC: "lenb@kernel.org" <lenb@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "Moore, Robert" <robert.moore@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "rob@landley.net" <rob@landley.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [RESEND PATCH 3/6] acpi: Remove the leading spaces of "finish_override"
 label in acpi_tb_table_override().
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com> <1362652697-30284-4-git-send-email-tangchen@cn.fujitsu.com> <1AE640813FDE7649BE1B193DEA596E88C197C2@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88C197C2@SHSMSX101.ccr.corp.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/08 16:39:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/08 16:39:28,
	Serialize complete at 2013/03/08 16:39:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 04:28 PM, Zheng, Lv wrote:
> Please do not try to fix ACPICA indentation problems in Linux side.
> This will introduce source code divergences between ACPICA and Linux, which will add difficulties to ACPICA release work.
> Please find real issues in ACPICA release scripts at:
>
> https://github.com/acpica/acpica/tree/master/generate/linux

Hi Lv,

Thanks for telling me this. :)

One more thing, if I want to fix something in acpica, such as this patch 
set,
who and which mail list should I send patches to ?

Thanks. :)

>
> Thanks
> -Lv
>
>> -----Original Message-----
>> From: Tang Chen [mailto:tangchen@cn.fujitsu.com]
>> Sent: Thursday, March 07, 2013 6:38 PM
>> To: lenb@kernel.org; rjw@sisk.pl; Moore, Robert; Zheng, Lv;
>> ming.m.lin@intel.com; mpm@selenic.com; herbert@gondor.apana.org.au;
>> rob@landley.net
>> Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-doc@vger.kernel.org; trivial@kernel.org
>> Subject: [RESEND PATCH 3/6] acpi: Remove the leading spaces of
>> "finish_override" label in acpi_tb_table_override().
>>
>> There is 7 leading spaces in front of "finish_override" label in
>> acpi_tb_table_override(). Remove them.
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   drivers/acpi/acpica/tbinstal.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c index
>> e57cd38..b1e098d 100644
>> --- a/drivers/acpi/acpica/tbinstal.c
>> +++ b/drivers/acpi/acpica/tbinstal.c
>> @@ -313,7 +313,7 @@ struct acpi_table_header
>> *acpi_tb_table_override(struct acpi_table_header
>>
>>   	return (NULL);		/* There was no override */
>>
>> -      finish_override:
>> +finish_override:
>>
>>   	ACPI_INFO((AE_INFO,
>>   		   "%4.4s %p %s table override, new table: %p",
>> --
>> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
