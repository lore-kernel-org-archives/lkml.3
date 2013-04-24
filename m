Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3DXRpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:45:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab3DXRpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:45:06 -0400
Message-ID: <51781A13.50705@ti.com>
Date: Wed, 24 Apr 2013 13:44:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/30] thermal: cpu_cooling: remove trailing white spaces
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com> <1366218743-20841-3-git-send-email-eduardo.valentin@ti.com> <744357E9AAD1214791ACBA4B0B9092632C9F6D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092632C9F6D@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-04-2013 10:48, Zhang, Rui wrote:
>
>
>> -----Original Message-----
>> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
>> Sent: Thursday, April 18, 2013 1:12 AM
>> To: amit.kachhap@linaro.org
>> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: [PATCH 02/30] thermal: cpu_cooling: remove trailing white
>> spaces
>> Importance: High
>>
>> Remove unnecessary white spaces.
>>
> The same comments for patch 02, 06, 09, 10, 11, 13, 18, and 30.
>
> Can we run Lindent to fix all the coding style problem in one patch?


Well, yes. The thing about Lindent is that it sometimes changes the code 
in a way we do not want. It will change cpu-cooling in slightly 
different way, but it will include most of the changes on the patches 
above. It misses some of the changes and also does some other that are 
not so nice.

I obviously would prefer to keep these patches, as, the patches are 
already there. Let me know what is your call.

>
> Thanks,
> rui
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>   drivers/thermal/cpu_cooling.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c
>> b/drivers/thermal/cpu_cooling.c index 778c43d..d0d6a0c 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -131,14 +131,13 @@ static int get_property(unsigned int cpu,
>> unsigned long input,
>>   	int descend = -1;
>>   	struct cpufreq_frequency_table *table =
>>   					cpufreq_frequency_get_table(cpu);
>> -
>> +
>>   	if (!output)
>>   		return -EINVAL;
>>
>>   	if (!table)
>>   		return -EINVAL;
>>
>> -
>>   	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
>>   		/* ignore invalid entries */
>>   		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> --
>> 1.8.2.1.342.gfa7285d
>
>
>

