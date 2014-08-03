Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaHCQj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:39:28 -0400
Received: from mx02.posteo.de ([89.146.194.165]:50716 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbaHCQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:39:26 -0400
Message-ID: <53DE6575.6070904@posteo.de>
Date: Sun, 03 Aug 2014 18:38:13 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192ee: checkpatch: use tabs for indent
References: <1407082009-17133-1-git-send-email-martink@posteo.de> <1407083245.12855.3.camel@joe-AO725>
In-Reply-To: <1407083245.12855.3.camel@joe-AO725>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-08-03 18:27, schrieb Joe Perches:
> On Sun, 2014-08-03 at 18:06 +0200, Martin Kepplinger wrote:
>> Use tabs for code indent and use the kernel coding style.
> []
>> diff --git a/drivers/staging/rtl8192ee/regd.c b/drivers/staging/rtl8192ee/regd.c
> []
>> @@ -363,8 +363,7 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
>>  static int _rtl92e_regd_init_wiphy(struct rtl_regulatory *reg,
>>  				   struct wiphy *wiphy,
>>  				   void (*reg_notifier)(struct wiphy *wiphy,
>> -						        struct regulatory_request *
>> -						        request))
>> +					struct regulatory_request *request))
>>  {
>>  	const struct ieee80211_regdomain *regd;
>>  
> 
> It seems that was done to keep the alignment of the function
> pointer arguments to the open parenthesis.
> 
> If I were to do anything, it'd be to move the static int
> to a separate line and unindent the block a little
> 
> For this file, maybe something like this:
> ---
>  drivers/staging/rtl8192ee/regd.c | 120 +++++++++++++++++++--------------------
>  1 file changed, 60 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192ee/regd.c b/drivers/staging/rtl8192ee/regd.c
> index 7272fae..4fcb5f0 100644
> --- a/drivers/staging/rtl8192ee/regd.c
> +++ b/drivers/staging/rtl8192ee/regd.c
> @@ -46,99 +46,99 @@ static struct country_code_to_enum_rd allcountries[] = {
>   *Only these channels all allow active
>   *scan on all world regulatory domains
>   */
> -#define RTL819x_2GHZ_CH01_11	\
> +#define RTL819x_2GHZ_CH01_11				\
>  	REG_RULE(2412-10, 2462+10, 40, 0, 20, 0)
>  
>  /*
>   *We enable active scan on these a case
>   *by case basis by regulatory domain
>   */
> -#define RTL819x_2GHZ_CH12_13	\
> -	REG_RULE(2467-10, 2472+10, 40, 0, 20,\
> -	NL80211_RRF_PASSIVE_SCAN)
> +#define RTL819x_2GHZ_CH12_13			\
> +	REG_RULE(2467-10, 2472+10, 40, 0, 20,	\
> +		 NL80211_RRF_PASSIVE_SCAN)
>  
> -#define RTL819x_2GHZ_CH14	\
> -	REG_RULE(2484-10, 2484+10, 40, 0, 20, \
> -	NL80211_RRF_PASSIVE_SCAN | \
> -	NL80211_RRF_NO_OFDM)
> +#define RTL819x_2GHZ_CH14			\
> +	REG_RULE(2484-10, 2484+10, 40, 0, 20,	\
> +		 NL80211_RRF_PASSIVE_SCAN |	\
> +		 NL80211_RRF_NO_OFDM)
>  
>  /* 5G chan 36 - chan 64*/
> -#define RTL819x_5GHZ_5150_5350	\
> -	REG_RULE(5150-10, 5350+10, 80, 0, 30, \
> -	NL80211_RRF_PASSIVE_SCAN | \
> -	NL80211_RRF_NO_IBSS)
> +#define RTL819x_5GHZ_5150_5350			\
> +	REG_RULE(5150-10, 5350+10, 80, 0, 30,	\
> +		 NL80211_RRF_PASSIVE_SCAN |	\
> +		 NL80211_RRF_NO_IBSS)
>  
>  /* 5G chan 100 - chan 165*/
> -#define RTL819x_5GHZ_5470_5850	\
> -	REG_RULE(5470-10, 5850+10, 80, 0, 30, \
> -	NL80211_RRF_PASSIVE_SCAN | \
> -	NL80211_RRF_NO_IBSS)
> +#define RTL819x_5GHZ_5470_5850			\
> +	REG_RULE(5470-10, 5850+10, 80, 0, 30,	\
> +		 NL80211_RRF_PASSIVE_SCAN |	\
> +		 NL80211_RRF_NO_IBSS)
>  
>  /* 5G chan 149 - chan 165*/
> -#define RTL819x_5GHZ_5725_5850	\
> -	REG_RULE(5725-10, 5850+10, 80, 0, 30, \
> -	NL80211_RRF_PASSIVE_SCAN | \
> -	NL80211_RRF_NO_IBSS)
> +#define RTL819x_5GHZ_5725_5850			\
> +	REG_RULE(5725-10, 5850+10, 80, 0, 30,	\
> +		 NL80211_RRF_PASSIVE_SCAN |	\
> +		 NL80211_RRF_NO_IBSS)
>  
> -#define RTL819x_5GHZ_ALL	\
> +#define RTL819x_5GHZ_ALL					\
>  	(RTL819x_5GHZ_5150_5350, RTL819x_5GHZ_5470_5850)
>  
>  static const struct ieee80211_regdomain rtl_regdom_11 = {
>  	.n_reg_rules = 1,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +	}
>  };
>  
>  static const struct ieee80211_regdomain rtl_regdom_12_13 = {
>  	.n_reg_rules = 2,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -			  RTL819x_2GHZ_CH12_13,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +		RTL819x_2GHZ_CH12_13,
> +	}
>  };
>  
>  static const struct ieee80211_regdomain rtl_regdom_no_midband = {
>  	.n_reg_rules = 3,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -			  RTL819x_5GHZ_5150_5350,
> -			  RTL819x_5GHZ_5725_5850,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +		RTL819x_5GHZ_5150_5350,
> +		RTL819x_5GHZ_5725_5850,
> +	}
>  };
>  
>  static const struct ieee80211_regdomain rtl_regdom_60_64 = {
>  	.n_reg_rules = 3,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -			  RTL819x_2GHZ_CH12_13,
> -			  RTL819x_5GHZ_5725_5850,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +		RTL819x_2GHZ_CH12_13,
> +		RTL819x_5GHZ_5725_5850,
> +	}
>  };
>  
>  static const struct ieee80211_regdomain rtl_regdom_14_60_64 = {
>  	.n_reg_rules = 4,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -			  RTL819x_2GHZ_CH12_13,
> -			  RTL819x_2GHZ_CH14,
> -			  RTL819x_5GHZ_5725_5850,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +		RTL819x_2GHZ_CH12_13,
> +		RTL819x_2GHZ_CH14,
> +		RTL819x_5GHZ_5725_5850,
> +	}
>  };
>  
>  static const struct ieee80211_regdomain rtl_regdom_14 = {
>  	.n_reg_rules = 3,
>  	.alpha2 = "99",
>  	.reg_rules = {
> -		      RTL819x_2GHZ_CH01_11,
> -			  RTL819x_2GHZ_CH12_13,
> -			  RTL819x_2GHZ_CH14,
> -		      }
> +		RTL819x_2GHZ_CH01_11,
> +		RTL819x_2GHZ_CH12_13,
> +		RTL819x_2GHZ_CH14,
> +	}
>  };
>  
>  static bool _rtl_is_radar_freq(u16 center_freq)
> @@ -146,8 +146,9 @@ static bool _rtl_is_radar_freq(u16 center_freq)
>  	return center_freq >= 5260 && center_freq <= 5700;
>  }
>  
> -static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
> -					   enum nl80211_reg_initiator initiator)
> +static void
> +_rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
> +			       enum nl80211_reg_initiator initiator)
>  {
>  	enum ieee80211_band band;
>  	struct ieee80211_supported_band *sband;
> @@ -186,20 +187,20 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
>  				if (!(reg_rule->flags &
>  				      NL80211_RRF_PASSIVE_SCAN))
>  					ch->flags &=
> -					    ~IEEE80211_CHAN_PASSIVE_SCAN;
> +						~IEEE80211_CHAN_PASSIVE_SCAN;
>  			} else {
>  				if (ch->beacon_found)
>  					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
> -						   IEEE80211_CHAN_PASSIVE_SCAN);
> +						       IEEE80211_CHAN_PASSIVE_SCAN);
>  			}
>  		}
>  	}
>  }
>  
>  /* Allows active scan scan on Ch 12 and 13 */
> -static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
> -					     enum nl80211_reg_initiator
> -					     initiator)
> +static void
> +_rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
> +				 enum nl80211_reg_initiator initiator)
>  {
>  	struct ieee80211_supported_band *sband;
>  	struct ieee80211_channel *ch;
> @@ -279,9 +280,9 @@ static void _rtl_reg_apply_radar_flags(struct wiphy *wiphy)
>  		 *do not allow AP mode
>  		 */
>  		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
> -			ch->flags |= IEEE80211_CHAN_RADAR |
> -			    IEEE80211_CHAN_NO_IBSS |
> -			    IEEE80211_CHAN_PASSIVE_SCAN;
> +			ch->flags |= (IEEE80211_CHAN_RADAR |
> +				      IEEE80211_CHAN_NO_IBSS |
> +				      IEEE80211_CHAN_PASSIVE_SCAN);
>  	}
>  }
>  
> @@ -332,8 +333,8 @@ static int _rtl92e_reg_notifier_apply(struct wiphy *wiphy,
>  	return 0;
>  }
>  
> -static const struct ieee80211_regdomain *_rtl_regdomain_select(
> -						struct rtl_regulatory *reg)
> +static const struct ieee80211_regdomain *
> +_rtl_regdomain_select(struct rtl_regulatory *reg)
>  {
>  	switch (reg->country_code) {
>  	case COUNTRY_CODE_FCC:
> @@ -360,11 +361,10 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
>  	}
>  }
>  
> -static int _rtl92e_regd_init_wiphy(struct rtl_regulatory *reg,
> -				   struct wiphy *wiphy,
> -				   void (*reg_notifier)(struct wiphy *wiphy,
> -						        struct regulatory_request *
> -						        request))
> +static int
> +_rtl92e_regd_init_wiphy(struct rtl_regulatory *reg, struct wiphy *wiphy,
> +			void (*reg_notifier)(struct wiphy *wiphy,
> +					     struct regulatory_request *request))
>  {
>  	const struct ieee80211_regdomain *regd;
>  
> 

I'd rather have the return value on the same line than aligned
parameters but that's taste. Either way looks better and satisfies
checkpatch, which is the only goal.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

