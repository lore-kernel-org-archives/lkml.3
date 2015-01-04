Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbbADKyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:54:13 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48132 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADKyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:54:11 -0500
Message-ID: <54A91BD0.8070106@kernel.org>
Date: Sun, 04 Jan 2015 10:54:08 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 08/10] iio: imu: kmx61: Remove unnecessary REG_INS1 read
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-9-git-send-email-daniel.baluta@intel.com> <54A550E7.7040808@gmx.de>
In-Reply-To: <54A550E7.7040808@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 13:51, Hartmut Knaack wrote:
> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>> Useful in the debugging phase, not needed now.
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Applied.
>> ---
>>  drivers/iio/imu/kmx61.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
>> index 5b5be2b..eb3900e 100644
>> --- a/drivers/iio/imu/kmx61.c
>> +++ b/drivers/iio/imu/kmx61.c
>> @@ -1196,8 +1196,6 @@ ack_intr:
>>  	if (ret < 0)
>>  		dev_err(&data->client->dev, "Error reading reg_inl\n");
>>  
>> -	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS1);
>> -
>>  	return IRQ_HANDLED;
>>  }
>>  
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

