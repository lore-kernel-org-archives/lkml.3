Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaGTMc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 08:32:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:37644 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaGTMc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 08:32:58 -0400
Message-ID: <53CBB785.2080207@kernel.org>
Date: Sun, 20 Jul 2014 13:35:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Reyad Attiyat <reyad.attiyat@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/4] iio: types: Added support for rotation from north
 usage attributes
References: <1405621109-21147-1-git-send-email-reyad.attiyat@gmail.com> <1405621109-21147-3-git-send-email-reyad.attiyat@gmail.com> <53CAFEBB.8030008@linux.intel.com>
In-Reply-To: <53CAFEBB.8030008@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/14 00:26, Srinivas Pandruvada wrote:
>
> On 07/17/2014 11:18 AM, Reyad Attiyat wrote:
>> Added the rotation from north usage attributes to the iio modifier enum and to the iio modifier names array.
>>
>> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git

Thanks,

J
>> ---
>>   drivers/iio/industrialio-core.c | 4 ++++
>>   include/linux/iio/types.h       | 4 ++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
>> index 4b1f375..af3e76d 100644
>> --- a/drivers/iio/industrialio-core.c
>> +++ b/drivers/iio/industrialio-core.c
>> @@ -87,6 +87,10 @@ static const char * const iio_modifier_names[] = {
>>       [IIO_MOD_QUATERNION] = "quaternion",
>>       [IIO_MOD_TEMP_AMBIENT] = "ambient",
>>       [IIO_MOD_TEMP_OBJECT] = "object",
>> +    [IIO_MOD_NORTH_MAGN] = "from_north_magnetic",
>> +    [IIO_MOD_NORTH_TRUE] = "from_north_true",
>> +    [IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
>> +    [IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
>>   };
>>   /* relies on pairs of these shared then separate */
>> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>> index d480631..d09c40d 100644
>> --- a/include/linux/iio/types.h
>> +++ b/include/linux/iio/types.h
>> @@ -56,6 +56,10 @@ enum iio_modifier {
>>       IIO_MOD_QUATERNION,
>>       IIO_MOD_TEMP_AMBIENT,
>>       IIO_MOD_TEMP_OBJECT,
>> +    IIO_MOD_NORTH_MAGN,
>> +    IIO_MOD_NORTH_TRUE,
>> +    IIO_MOD_NORTH_MAGN_TILT_COMP,
>> +    IIO_MOD_NORTH_TRUE_TILT_COMP
>>   };
>>   enum iio_event_type {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

