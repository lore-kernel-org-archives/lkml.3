Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3DXRdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:33:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37390 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3DXRdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:33:42 -0400
Message-ID: <51781763.60209@ti.com>
Date: Wed, 24 Apr 2013 13:33:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com> <1366218743-20841-27-git-send-email-eduardo.valentin@ti.com> <744357E9AAD1214791ACBA4B0B9092632C9FCF@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092632C9FCF@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-04-2013 10:52, Zhang, Rui wrote:
>
>
>> -----Original Message-----
>> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
>> Sent: Thursday, April 18, 2013 1:12 AM
>> To: amit.kachhap@linaro.org
>> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
>> Importance: High
>>
>> The list is needed so far. Thus removing it.
>>
> s/needed/not needed?
>

yes, thanks.

> Thanks,
> rui
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>   drivers/thermal/cpu_cooling.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c
>> b/drivers/thermal/cpu_cooling.c index 3709274..825231f 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -38,11 +38,9 @@
>>    * @cpufreq_val: integer value representing the absolute value of the
>> clipped
>>    *	frequency.
>>    * @allowed_cpus: all the cpus involved for this
>> cpufreq_cooling_device.
>> - * @node: list_head to link all cpufreq_cooling_device together.
>>    *
>>    * This structure is required for keeping information of each
>> - * cpufreq_cooling_device registered as a list whose head is
>> represented by
>> - * cooling_cpufreq_list. In order to prevent corruption of this list a
>> + * cpufreq_cooling_device registered. In order to prevent corruption
>> of
>> + this a
>>    * mutex lock cooling_cpufreq_lock is used.
>>    */
>>   struct cpufreq_cooling_device {
>> @@ -51,9 +49,7 @@ struct cpufreq_cooling_device {
>>   	unsigned int cpufreq_state;
>>   	unsigned int cpufreq_val;
>>   	struct cpumask allowed_cpus;
>> -	struct list_head node;
>>   };
>> -static LIST_HEAD(cooling_cpufreq_list);  static
>> DEFINE_IDR(cpufreq_idr);  static DEFINE_MUTEX(cooling_cpufreq_lock);
>>
>> --
>> 1.8.2.1.342.gfa7285d
>
>
>

