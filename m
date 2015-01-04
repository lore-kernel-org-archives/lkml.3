Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbbADKr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:47:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48060 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:47:26 -0500
Message-ID: <54A91A3B.8010607@kernel.org>
Date: Sun, 04 Jan 2015 10:47:23 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 04/10] iio: imu: kmx61: Fixup parameters alignment
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-5-git-send-email-daniel.baluta@intel.com> <54A55005.3080108@gmx.de>
In-Reply-To: <54A55005.3080108@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 13:47, Hartmut Knaack wrote:
> Daniel Baluta schrieb am 23.12.2014 um 14:22:
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Applied.
>> ---
>>  drivers/iio/imu/kmx61.c | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
>> index 4fc4f63..2652179 100644
>> --- a/drivers/iio/imu/kmx61.c
>> +++ b/drivers/iio/imu/kmx61.c
>> @@ -926,11 +926,11 @@ static int kmx61_read_event(struct iio_dev *indio_dev,
>>  }
>>  
>>  static int kmx61_write_event(struct iio_dev *indio_dev,
>> -			    const struct iio_chan_spec *chan,
>> -			    enum iio_event_type type,
>> -			    enum iio_event_direction dir,
>> -			    enum iio_event_info info,
>> -			    int val, int val2)
>> +			     const struct iio_chan_spec *chan,
>> +			     enum iio_event_type type,
>> +			     enum iio_event_direction dir,
>> +			     enum iio_event_info info,
>> +			     int val, int val2)
>>  {
>>  	struct kmx61_data *data = kmx61_get_data(indio_dev);
>>  
>> @@ -962,10 +962,10 @@ static int kmx61_read_event_config(struct iio_dev *indio_dev,
>>  }
>>  
>>  static int kmx61_write_event_config(struct iio_dev *indio_dev,
>> -				   const struct iio_chan_spec *chan,
>> -				   enum iio_event_type type,
>> -				   enum iio_event_direction dir,
>> -				   int state)
>> +				    const struct iio_chan_spec *chan,
>> +				    enum iio_event_type type,
>> +				    enum iio_event_direction dir,
>> +				    int state)
>>  {
>>  	struct kmx61_data *data = kmx61_get_data(indio_dev);
>>  	int ret = 0;
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

