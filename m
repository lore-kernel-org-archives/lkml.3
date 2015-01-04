Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbbADKlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:41:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48018 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbbADKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:41:22 -0500
Message-ID: <54A918D0.9060603@kernel.org>
Date: Sun, 04 Jan 2015 10:41:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 01/10] iio: imu: kmx61: Save odr_bits for later use
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-2-git-send-email-daniel.baluta@intel.com> <54A54F6B.1010307@gmx.de>
In-Reply-To: <54A54F6B.1010307@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 13:45, Hartmut Knaack wrote:
> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
Applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to play.
>> ---
>>  drivers/iio/imu/kmx61.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
>> index 972424b..fe0cee7 100644
>> --- a/drivers/iio/imu/kmx61.c
>> +++ b/drivers/iio/imu/kmx61.c
>> @@ -465,6 +465,8 @@ static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
>>  	if (ret < 0)
>>  		return ret;
>>  
>> +	data->odr_bits = odr_bits;
>> +
>>  	if (device & KMX61_ACC) {
>>  		ret = kmx61_set_wake_up_odr(data, val, val2);
>>  		if (ret)
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

