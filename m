Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbbADKtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:49:50 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48082 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADKts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:49:48 -0500
Message-ID: <54A91ACA.3090508@kernel.org>
Date: Sun, 04 Jan 2015 10:49:46 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 06/10] iio: imu: kmx61: Use false instead of 0 for ev_enable_state
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-7-git-send-email-daniel.baluta@intel.com> <54A55094.6010800@gmx.de>
In-Reply-To: <54A55094.6010800@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 13:50, Hartmut Knaack wrote:
> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Applied
>> ---
>>  drivers/iio/imu/kmx61.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
>> index 332ee67..30825cf 100644
>> --- a/drivers/iio/imu/kmx61.c
>> +++ b/drivers/iio/imu/kmx61.c
>> @@ -976,7 +976,7 @@ static int kmx61_write_event_config(struct iio_dev *indio_dev,
>>  	mutex_lock(&data->lock);
>>  
>>  	if (!state && data->motion_trig_on) {
>> -		data->ev_enable_state = 0;
>> +		data->ev_enable_state = false;
>>  		goto err_unlock;
>>  	}
>>  
>>
> 

