Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbALHQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:16:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15531 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbALHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:15:57 -0500
X-AuditID: cbfee68d-f79296d000004278-cb-54b374ab6682
Date: Mon, 12 Jan 2015 07:15:55 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 02/10] devfreq: event: Add the list of supported
 devfreq-event type
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112070622786@myungjoo.ham
Msgkey: 20150112070622786@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112070622786@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <768125446.886831421046952335.JavaMail.weblogic@epmlwas09a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkWHd1yeYQg9ML1Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhddHGAv2KVbcunWIsYHxjEIXIyeHkIC6xKIlJ9lAbAkBE4kd
	h7awQthiEhfurQeKcwHVLGWUOHllHhNM0ZSGWawQiTmMEtsmHgPrYBFQlVi6eAt7FyMHB5uA
	nsTMz8kgYWGBSIlJnYvZQWwRgTyJK3dnMIL0Mgv0sEl0XP3ODHGFksSafa9YQGxeAUGJkzOf
	sEAsU5X49O0YO0RcTeLkjAlQl4pLXJh7iR3C5pWY0f4Uql5OYtrXNcwQtrTE+VkbGGG+Wfz9
	MVScX+LY7R1QzwhITD1zEKpGS2La9flQc/gk1ix8ywJTv+vUcmaYXfe3zIXqlZDY2vIE7Hdm
	AUWJKd0PwX5nFtCUWL9LH90rvALuElN+bQcHqITAVA6J450zWCcwKs1CUjcLyahZCKOQlSxg
	ZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJEZgYTv971ruD8fYB60OMAhyMSjy8FlKbQ4RY
	E8uKK3MPMZoCY2kis5Rocj4w/eSVxBsamxlZmJqYGhuZW5opifMqSv0MFhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cA4K0/ipNqiyEkFao+s7+Wzc0xWNyiJqep9OXXnpdMasjrlET0y++yL
	P86a+NzU5NdsnhlrnokbLj2tmxTwPm7dPv3KDanG32e5d+1wEd4ZG2/RzH904bMd0rm2m65W
	HIw4Eb3w/VFtX8/tvzeX7C+fpr5yr8zO3VUShf77mFd4yLIsDDglv+2XEktxRqKhFnNRcSIA
	zXPBpwcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tXt3VJZtDDK68kbO4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkX
	Xh9hLNinWHHr1iHGBsYzCl2MnBxCAuoSi5acZAOxJQRMJKY0zGKFsMUkLtxbDxTnAqqZwyix
	beIxsASLgKrE0sVb2LsYOTjYBPQkZn5OBgkLC0RKTOpczA5iiwjkSVy5O4MRpJdZoIdNouPq
	d2aIZUoSa/a9YgGxeQUEJU7OfMICsUxV4tO3Y+wQcTWJkzMmQB0kLnFh7iV2CJtXYkb7U6h6
	OYlpX9cwQ9jSEudnbWCEOXrx98dQcX6JY7d3MEHYAhJTzxyEqtGSmHZ9PtQcPok1C9+ywNTv
	OrWcGWbX/S1zoXolJLa2PAH7nVlAUWJK90Ow35kFNCXW79JH9wqvgLvElF/b2SYwys5CkpqF
	pHsWQjeykgWMLKsYRVMLkguKk9IrjPSKE3OLS/PS9ZLzczcxgpPQs0U7GP+dtz7EKMDBqMTD
	ayG1OUSINbGsuDL3EKMEB7OSCG+YNVCINyWxsiq1KD++qDQntfgQoykwziYyS4km5wMTZF5J
	vKGxsYmZiamliYWBqbmSOO//c7khQgLpiSWp2ampBalFMH1MHJxSDYx7hM5wL1G4xGQQYFmW
	tbC6Xk50+bS+640yL4/NWZ5/V35jH2tORKLRzgUP0gOZuTkC9Ob+S4r2UG7Itts237Xg2dyS
	F1u+65hqfDoye0/hn84vHysXqEicOS72/7eBZPtq7VKRo95/zU823/9T9/NLrdGLOSsTJrJv
	nnzpJ/OGTbOzpDdLb+RXYinOSDTUYi4qTgQAfycDflgDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C7G5mp016312

>   
>  This patch adds the list of supported devfreq-event type as following.
> Each devfreq-event device driver would support the various devfreq-event type
> for devfreq governor at the same time.
> - DEVFREQ_EVENT_TYPE_RAW_DATA
> - DEVFREQ_EVENT_TYPE_UTILIZATION
> - DEVFREQ_EVENT_TYPE_BANDWIDTH
> - DEVFREQ_EVENT_TYPE_LATENCY

Did you try to say:

A devfreq-event device may support multiple devfreq-event types
simultaneously.

If so, your switch expressions are going to screw up.


> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/devfreq-event.c | 58 ++++++++++++++++++++++++++++++++++++-----
>  include/linux/devfreq-event.h   | 25 +++++++++++++++---
>  2 files changed, 73 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
> index 81448ba..64c1764 100644
> --- a/drivers/devfreq/devfreq-event.c
> +++ b/drivers/devfreq/devfreq-event.c
>  
[]
> -	mutex_lock(&edev->lock);
> -	ret = edev->desc->ops->get_event(edev, edata);
> -	mutex_unlock(&edev->lock);
> +	switch (type) {

Bitwise value with switch? (what if type = RAW_DATA | BANDWIDTH, meaning
this is raw data of the bandwitdh.)

> +	case DEVFREQ_EVENT_TYPE_RAW_DATA:
> +	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
> +	case DEVFREQ_EVENT_TYPE_LATENCY:
> +		if ((edata->event > EVENT_TYPE_RAW_DATA_MAX) ||
> +			(edata->total_event > EVENT_TYPE_RAW_DATA_MAX)) {

Is it possible for unsigned long edata->event/total_event to be
  > EVENT_TYPE_RAW_DATA_MAX = ULONG_MAX?

What was your intention?

If you were trying to detect overflow, you need to rethink about it.
If not, (overflow is harmless or not going to happen) you don't need to
check it.


> +			edata->event = edata->total_event = 0;
> +			ret = -EINVAL;
> +		}
> +		break;
> +	case DEVFREQ_EVENT_TYPE_UTILIZATION:
> +		edata->total_event = EVENT_TYPE_UTILIZATION_MAX;
>  
> -	if ((edata->total_event <= 0)
> -		|| (edata->event > edata->total_event)) {
> +		if (edata->event > EVENT_TYPE_UTILIZATION_MAX) {
> +			edata->event = edata->total_event = 0;
> +			ret = -EINVAL;
> +		}
> +		break;
> +	default:
>  		edata->event = edata->total_event = 0;
>  		ret = -EINVAL;
> +		break;
>  	}
>  
> +	mutex_unlock(&edev->lock);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(devfreq_event_get_event);
> diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
> index b7363f5..13a5703 100644
> --- a/include/linux/devfreq-event.h
> +++ b/include/linux/devfreq-event.h
> @@ -36,6 +36,14 @@ struct devfreq_event_dev {
>  	const struct devfreq_event_desc *desc;
>  };
>  
> +/* The supported type by devfreq-event device */
> +enum devfreq_event_type {
> +	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(0),
> +	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(1),
> +	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(2),
> +	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(3),
> +};
> +

(Being curious) Is it possible to have multiple types
simultaneously?


[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
