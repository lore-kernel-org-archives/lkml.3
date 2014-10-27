Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaJ0Fpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaJ0Fpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:45:40 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Paul McQuade <paulmcquad@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] staging: rtl8723au:core
References: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
	<1414350250.15751.22.camel@perches.com>
Date: Mon, 27 Oct 2014 06:45:27 +0100
In-Reply-To: <1414350250.15751.22.camel@perches.com> (Joe Perches's message of
	"Sun, 26 Oct 2014 12:04:10 -0700")
Message-ID: <wrfjegtucbgo.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Sun, 2014-10-26 at 16:18 +0000, Paul McQuade wrote:
>> ERROR: spaces required around that ':' (ctx:VxE)
>> 
>> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> index 6274cb3..41006cf 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> @@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
>>  
>>  	if (rf_type == RF_1T1R) {
>>  		if (mcs->rx_mask[0] & BIT(7))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
>>  				((short_GI_20)?722:650);
>>  		else if (mcs->rx_mask[0] & BIT(6))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215) :
>>  				((short_GI_20)?650:585);
>>  		else if (mcs->rx_mask[0] & BIT(5))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080) :
>>  				((short_GI_20)?578:520);
>>  		else if (mcs->rx_mask[0] & BIT(4))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810) :
>>  				((short_GI_20)?433:390);
>>  		else if (mcs->rx_mask[0] & BIT(3))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540) :
>>  				((short_GI_20)?289:260);
>>  		else if (mcs->rx_mask[0] & BIT(2))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405) :
>>  				((short_GI_20)?217:195);
>>  		else if (mcs->rx_mask[0] & BIT(1))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270) :
>>  				((short_GI_20)?144:130);
>>  		else if (mcs->rx_mask[0] & BIT(0))
>> -			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):
>> +			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135) :
>>  				((short_GI_20)?72:65);
>
> A macro could help intelligibility here - maybe something like:
>
> #define get_max_rate(r1, r2, r3, r4)					\
> 	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
> and:
>  		if (mcs->rx_mask[0] & BIT(7))
> 			max_rate = get_max_rate(1500, 1350, 722, 650);

Hiding a parameter to a macro like that is bad coding practice, so don't
do that please!

Jes
