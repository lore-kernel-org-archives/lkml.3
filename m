Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3EQMRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:17:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40349 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3EQMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:17:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fef6d000002d62-54-51961fe6220f
Content-transfer-encoding: 8BIT
Message-id: <51961FE4.60105@samsung.com>
Date: Fri, 17 May 2013 21:17:40 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 16/30] thermal: exynos: Make the zone handling dependent
 on trip count
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
 <1368525540-15034-17-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1368525540-15034-17-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkRPeZ/LRAg51NphYNV0Msfr2byW6x
	Zv9PJoveBVfZLC7vmsNm8bn3CKPFjPP7mCyePOxjc+Dw2DnrLrvH4j0vmTz6tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZh/oesxUs0KiYuOE9UwNjh2IXIyeHhICJxNrJTxghbDGJ
	C/fWs3UxcnEICSxllNh59zwTTNGcaf8ZIRLTGSV6bt5jB0nwCghK/Jh8j6WLkYODWUBe4sil
	bJAws4C6xKR5i5gh6l8ySuxd+oIFol5D4s+mtWC9LAKqEg8PrWEFsdkE5CTeNn0Du0JUIEzi
	6oTjYPUiAoYSxw8sBbuIWeAN0EVHZrGBJIQF4iUuHV3CDrGhjVHi1IVNYFM5BTwlDp/ZwAqS
	kBC4xy4x4cx+Foh1AhLfJh8CO1VCQFZi0wFmiNckJQ6uuMEygVFsFpKHZiE8NAvJQwsYmVcx
	iqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbg6X/PJu5gvH/A+hBjMtDGicxSosn5wAjOK4k3
	NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjs0l4Mafm
	oTx+Bqd3jzgzdN3e7/xz7lNv3JqitSJl8y0NSgUUL8TwLL6p89OlU22S5ZOOpW1q6TsaT7/4
	FS2UdJfThkNgwrwjHL0PPr66vCBi/eHKTpVlG1xFbzpt77qqryjpJHyez2o+r58Pf4DGmRLD
	pCcTHipGcXMd3XZdKlv/frnSBm8lluKMREMt5qLiRAB+Z7L81gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd1n8tMCDTYv0rFouBpi8evdTHaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2Tx5GEfmwOHx85Zd9k9Fu95yeTRt2UVo8fxG9uZ
	PD5vkgtgjWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHGo7zFbwQKNiokb
	3jM1MHYodjFyckgImEjMmfafEcIWk7hwbz1bFyMXh5DAdEaJnpv32EESvAKCEj8m32PpYuTg
	YBaQlzhyKRskzCygLjFp3iJmiPqXjBJ7l75ggajXkPizaS1YL4uAqsTDQ2tYQWw2ATmJt03f
	wJaJCoRJXJ1wHKxeRMBQ4viBpWCLmQXeMErsPDKLDSQhLBAvcenoEnaIDW2MEqcubAKbying
	KXH4zAbWCYwCs5AcOAvhwFlIDlzAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi+n0nt
	YFzZYHGIUYCDUYmHV+HnlEAh1sSy4srcQ4wSHMxKIrzHP04NFOJNSaysSi3Kjy8qzUktPsSY
	DPTeRGYp0eR8YOrJK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5O
	qQbGY39jk2TL5ty+s+dAkuSXOKY5W16GpGwMqH4wnbFs1d9JFfnpXKrXxdmuL/TVOZrrzNyr
	/kB6zSTlqLMvvlZbRO0zs24uyfodXyB15l8V05TNVmX32Nnsgx8HXT7g4nnK7NyF7Yyua7wT
	zLrPKD57pM+tI/GyV+lKZdcMYYnZ/dxa2Xd/9exQYinOSDTUYi4qTgQAgCL6UzMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 05월 14일 18:58, Amit Daniel Kachhap wrote:

> This code simplifies the zone handling to use the trip count passed
> by the TMU driver. This also helps in adding more zone support.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |   55 ++++++++++++-----------
>  drivers/thermal/samsung/exynos_thermal_common.h |    2 -
>  2 files changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index 86d39aa..2369417 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -78,17 +78,16 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
>  static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
>  				 enum thermal_trip_type *type)
>  {
> -	switch (GET_ZONE(trip)) {
> -	case MONITOR_ZONE:
> -	case WARN_ZONE:
> -		*type = THERMAL_TRIP_ACTIVE;
> -		break;
> -	case PANIC_ZONE:
> -		*type = THERMAL_TRIP_CRITICAL;
> -		break;
> -	default:
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
> +	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
> +
> +	if (trip < 0 || trip >= max_trip)
>  		return -EINVAL;
> -	}
> +	else if (trip == (max_trip - 1))
> +		*type = THERMAL_TRIP_CRITICAL;
> +	else
> +		*type = THERMAL_TRIP_ACTIVE;
> +


 In current exynos_thermal driver, it is hard to set various trip type for each
trip, especially passive type. (not impossible, but complicated)

What do you think we just keep trip information with trip temperature in private
data? I mean if we just make trip level information to driver's private data
(like exynos_thermal_zone), it might be helpful to control trip type and trip
temperature. Like this,

struct exynos_thermal_trip_info {
	int trip_temp;
	enum thermal_trip_type type;
};
struct exynos_thermal_device {	
	.
	struct exynos_thermal_trip_info *trips;
	int num_trips;
};

Thanks,
Jonghwa

>  	return 0;
>  }
>  
> @@ -97,8 +96,9 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>  				unsigned long *temp)
>  {
>  	struct exynos_thermal_zone *th_zone = thermal->devdata;
> +	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
>  
> -	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
> +	if (trip < 0 || trip >= max_trip)
>  		return -EINVAL;
>  
>  	*temp = th_zone->sensor_conf->trip_data.trip_val[trip];
> @@ -112,10 +112,10 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>  static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
>  				unsigned long *temp)
>  {
> -	int ret;
> -	/* Panic zone */
> -	ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
> -	return ret;
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
> +	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
> +	/* Get the temp of highest trip*/
> +	return exynos_get_trip_temp(thermal, max_trip - 1, temp);
>  }
>  
>  /* Bind callback functions for thermal zone */
> @@ -340,19 +340,22 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>  		return -ENOMEM;
>  
>  	th_zone->sensor_conf = sensor_conf;
> -	cpumask_set_cpu(0, &mask_val);
> -	th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
> -	if (IS_ERR(th_zone->cool_dev[0])) {
> -		pr_err("Failed to register cpufreq cooling device\n");
> -		ret = -EINVAL;
> -		goto err_unregister;
> +	if (sensor_conf->cooling_data.freq_clip_count > 0) {
> +		cpumask_set_cpu(0, &mask_val);
> +		th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
> +		if (IS_ERR(th_zone->cool_dev[0])) {
> +			pr_err("Failed to register cpufreq cooling device\n");
> +			ret = -EINVAL;
> +			goto err_unregister;
> +		}
> +		th_zone->cool_dev_size++;
>  	}
> -	th_zone->cool_dev_size++;
>  
> -	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
> -			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
> -			sensor_conf->trip_data.trigger_falling ?
> -			0 : IDLE_INTERVAL);
> +	th_zone->therm_dev = thermal_zone_device_register(
> +			sensor_conf->name, sensor_conf->trip_data.trip_count,
> +			0, th_zone, &exynos_dev_ops, NULL, 0,
> +			sensor_conf->trip_data.trigger_falling ? 0 :
> +			IDLE_INTERVAL);
>  
>  	if (IS_ERR(th_zone->therm_dev)) {
>  		pr_err("Failed to register thermal zone device\n");
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
> index 59138ae..7b938e1 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -42,8 +42,6 @@
>  #define GET_ZONE(trip) (trip + 2)
>  #define GET_TRIP(zone) (zone - 2)
>  
> -#define EXYNOS_ZONE_COUNT	3
> -
>  /**
>   * struct freq_clip_table
>   * @freq_clip_max: maximum frequency allowed for this cooling state.


