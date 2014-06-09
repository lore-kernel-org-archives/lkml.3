Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaFIRu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:50:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:59708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaFIRuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:50:25 -0400
Message-ID: <5395F44F.8010005@kernel.org>
Date: Mon, 09 Jun 2014 18:52:15 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCHv2 2/3] IIO: Add iio_chan modifier for True/Magnetic North
 HID usages
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com> <1401750890-31854-3-git-send-email-reyad.attiyat@gmail.com> <5395F424.4070407@kernel.org>
In-Reply-To: <5395F424.4070407@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 18:51, Jonathan Cameron wrote:
> On 03/06/14 00:14, Reyad Attiyat wrote:
>> Updated iio modifier enum for compass north usages,
>> including magnetic/true north with tilt compensation.
>>
>> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> This looks fine.
gah. With the from_ prefix you suggested of course!
>> ---
>>   drivers/iio/industrialio-core.c | 4 ++++
>>   include/linux/iio/types.h       | 4 ++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
>> index ede16aec..2f523b5 100644
>> --- a/drivers/iio/industrialio-core.c
>> +++ b/drivers/iio/industrialio-core.c
>> @@ -84,6 +84,10 @@ static const char * const iio_modifier_names[] = {
>>       [IIO_MOD_LIGHT_RED] = "red",
>>       [IIO_MOD_LIGHT_GREEN] = "green",
>>       [IIO_MOD_LIGHT_BLUE] = "blue",
>> +    [IIO_MOD_NORTH_MAGN] = "north_magnetic",
>> +    [IIO_MOD_NORTH_TRUE] = "north_true",
>> +    [IIO_MOD_NORTH_MAGN_TILT_COMP] = "north_magnetic_tilt_comp",
>> +    [IIO_MOD_NORTH_TRUE_TILT_COMP] = "north_true_tilt_comp",
>>   };
>>
>>   /* relies on pairs of these shared then separate */
>> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>> index 084d882..5bf8847 100644
>> --- a/include/linux/iio/types.h
>> +++ b/include/linux/iio/types.h
>> @@ -53,6 +53,10 @@ enum iio_modifier {
>>       IIO_MOD_LIGHT_RED,
>>       IIO_MOD_LIGHT_GREEN,
>>       IIO_MOD_LIGHT_BLUE,
>> +    IIO_MOD_NORTH_MAGN,
>> +    IIO_MOD_NORTH_TRUE,
>> +    IIO_MOD_NORTH_MAGN_TILT_COMP,
>> +    IIO_MOD_NORTH_TRUE_TILT_COMP
>>   };
>>
>>   enum iio_event_type {
>>
>

