Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3EUDk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:40:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3EUDk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:40:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f276d000002279-1b-519aecc2b572
Content-transfer-encoding: 8BIT
Message-id: <519AECBD.9060202@samsung.com>
Date: Tue, 21 May 2013 12:40:45 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
 point only.
References: <1368870663-1225-1-git-send-email-jonghwa3.lee@samsung.com>
 <744357E9AAD1214791ACBA4B0B90926301102442@SHSMSX101.ccr.corp.intel.com>
In-reply-to: <744357E9AAD1214791ACBA4B0B90926301102442@SHSMSX101.ccr.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkWPfQm1mBBgtv8FsseTCF0WLN/p9M
	Fpd3zWGz+Nx7hNHiduMKNosnD/vYHNg8Fu95yeRx59oeNo++LasYPY7f2M7k8XmTXABrFJdN
	SmpOZllqkb5dAlfGsmuXWAqeSle8vPCcsYHxmFgXIyeHhICJxJuzK5khbDGJC/fWs3UxcnEI
	CSxllHjW/pkdpujRpc2sEIlFjBIzFn0DS/AKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmL
	mCHqXzJKrJk+gxWiXktixuwVLCA2i4CqxOfrx8DibAJyEm+bvjGC2KICYRJXJxwHqxERUJM4
	9+8HE8ggZoFmJokp27eCFQkLREpc3XCPCWLDREaJ3UsmM4NcwQnUffqwBsTVl9glXj0qhlgm
	IPFt8iGwQyUEZCU2HYD6WFLi4IobLBMYxWYheWcWwjuzkLyzgJF5FaNoakFyQXFSepGRXnFi
	bnFpXrpecn7uJkZgrJ3+96xvB+PNA9aHGJOBNk5klhJNzgfGal5JvKGxmZGFqYmpsZG5pRlp
	wkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGCdqOax+f4BNX0tN+jL7oeLdxSZ2
	a3qS7GducHWwNnsc8HiF4PKClpUxyXsMF98zDyiX5t4UGHru7JyC295shXfrS1WYF01arJmu
	6RafJvUieXtH6lbPmtA1Kgv/5R1bqC2xeVK94/9ftV09pTMyLz4VihW66PH7ablrGdNB18iK
	DJdM1UwWJZbijERDLeai4kQAIJgDCMsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd1Db2YFGsz7xGax5MEURos1+38y
	WVzeNYfN4nPvEUaL240r2CyePOxjc2DzWLznJZPHnWt72Dz6tqxi9Dh+YzuTx+dNcgGsUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5Zdu8RS8FS64uWF54wNjMfEuhg5
	OSQETCQeXdrMCmGLSVy4t56ti5GLQ0hgEaPEjEXf2EESvAKCEj8m32PpYuTgYBaQlzhyKRsk
	zCygLjFp3iJmiPqXjBJrps9ghajXkpgxewULiM0ioCrx+foxsDibgJzE26ZvjCC2qECYxNUJ
	x8FqRATUJM79+8EEMohZoJlJYsr2rWBFwgKRElc33GOC2DCRUWL3ksnMIFdwAnWfPqwxgVFg
	FpL7ZiHcNwvJfQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfyM+kdjKsaLA4xCnAw
	KvHwChjOChRiTSwrrsw9xCjBwawkwvu9GSjEm5JYWZValB9fVJqTWnyIMRnou4nMUqLJ+cA0
	k1cSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjCliShsOrnua
	/3atnNdEhtcSP4q/9CyNv1I5f/fXgj2iz99Vxdy3LRVwlQs9tESgRXLPWtndnwVKerPvxL//
	xhJ7fPmCxRGP/4acaHi34/D/FbvsnUv15j3Tm5wpcndHfERuaL7v2kOS7nEHrigu38HIrrkz
	zfvN/TkKXjOnCWc35nw7yhaeOEOJpTgj0VCLuag4EQBqS406KQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 05월 21일 01:00, Zhang, Rui wrote:

> 
> 
>> -----Original Message-----
>> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
>> Sent: Saturday, May 18, 2013 5:51 PM
>> To: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; Zhang, Rui; Eduardo Valentin; Amit
>> Dinel Kachhap; Jonghwa Lee; MyungJoo Ham
>> Subject: [PATCH 3/3] Thermal:core: Handle trips focused on current trip
>> point only.
>> Importance: High
>>
>> When thermal zone device is updated, it doesn't need to check every
>> trip points and its handling mathod even current temperature doesn't
>> exceed the trip's temperature. To modify those dissipatve mechanism,
>> this patch introduces the way to get current thermal trip point to call
>> only correspond trip point handling.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> NAK.
> 
>> ---
>>  drivers/thermal/thermal_core.c |   28 +++++++++++++++++-----------
>>  1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_core.c
>> b/drivers/thermal/thermal_core.c index ce4384a..1cc4825 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -333,14 +333,6 @@ static void handle_non_critical_trips(struct
>> thermal_zone_device *tz,  static void handle_critical_trips(struct
>> thermal_zone_device *tz,
>>  				int trip, enum thermal_trip_type trip_type)  {
>> -	long trip_temp;
>> -
>> -	tz->ops->get_trip_temp(tz, trip, &trip_temp);
>> -
>> -	/* If we have not crossed the trip_temp, we do not care. */
>> -	if (tz->temperature < trip_temp)
>> -		return;
>> -
>>  	if (tz->ops->notify)
>>  		tz->ops->notify(tz, trip, trip_type);
>>
>> @@ -437,14 +429,28 @@ static void update_temperature(struct
>> thermal_zone_device *tz)
>>  	mutex_unlock(&tz->lock);
>>  }
>>
>> +static int thermal_zone_get_current_trip(struct thermal_zone_device
>> +*tz) {
>> +	int trip;
>> +	long trip_temp;
>> +
>> +	for (trip = tz->trips - 1; trip > 0; trip--) {
>> +		tz->ops->get_trip_temp(tz, trip, &trip_temp);
>> +		if (tz->temperature > trip_temp)
>> +			continue;
>> +	}
>> +	return trip;
>> +}
>> +
>>  void thermal_zone_device_update(struct thermal_zone_device *tz)  {
>> -	int count;
>> +	int trip;
>>
>>  	update_temperature(tz);
>>
>> -	for (count = 0; count < tz->trips; count++)
>> -		handle_thermal_trip(tz, count);
>> +	trip = thermal_zone_get_current_trip(tz);
>> +
>> +	handle_thermal_trip(tz, trip);
> 
> Say, trip point 1 for thermal zone 0 is 60C,
> The system is running above 60C for somethime,
> thus the thermal_instance for this trip point is running at upper_limit.
> When the temperature suddenly drops below 60C,
> we still need to handle trip point 1 to deactivate it.
> 


Okay, I understood. I missed the point that governor will handle a cooling
device within certain trip point described in thermal instance.
But still I don't think this is the best behaviour. Let say we were in trip
level 2nd and moving to trip level 1st then we should call governor twice for
applying trip 1 level. Why don't we just call once? And whenever we call
handle_thermal_trip() with all trips, monitor_thermal_work() will also be called
at the same time. I think we can make this work more clearly and intuitively.
let me think of it more,,,

Thanks,
Jonghwa.

> Thanks,
> rui
>>  }
>>  EXPORT_SYMBOL_GPL(thermal_zone_device_update);
>>
>> --
>> 1.7.9.5
> 
> 


