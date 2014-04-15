Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaDOBgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:36:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22375 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDOBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:36:03 -0400
X-AuditID: cbfee690-b7f266d00000287c-e3-534c8d01d807
Date: Tue, 15 Apr 2014 01:36:01 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
To: Saravana Kannan <skannan@codeaurora.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140415012012184@myungjoo.ham
Msgkey: 20140415012012184@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140415012012184@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8568895.444151397525760132.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSqMvY6xNsMPW8pMXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr4sPkia0GPRMXCb3PZGhh3iHcxcnIICahLLFpykg3ElhAwkVi7
	5wGULSZx4d56IJsLqGYpo8SfnutMMEWnjk2BSsxnlFj8fwIrSIJFQFVi17If7F2MHBxsAuYS
	92cEgYSFBfwljvYfZgexRQT0JI40rWAF6WUWOM8kcbHrFBPEFUoSa/a9YgGxeQUEJU7OfMIC
	sUxV4nLjKqi4mkTrobWsEHEJiVnTL0DZvBIz2p9C1ctJTPu6hhnClpY4P2sDI8w3i78/horz
	Sxy7vYMJ5E6Q3if3g2HG7N78Bep5AYmpZw5CtWpJrFx/Hcrmk1iz8C0LzJhdp5Yzw/Te3zIX
	7BVmAUWJKd0P2SFsLYkvP/axoXuLV8BR4s/MPpYJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckF
	xUnpRSZ6xYm5xaV56XrJ+bmbGIGJ4fS/ZxN2MN47YH2IMRkYJROZpUST84GJJa8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKedFtjwY/P0Tw05
	Bn/PKr84dfta74WqBEllbjvLVRuUU2brxGVE5fIxZVq9Mqnsuuh01td6xr+tM09O7RVd+Onk
	2wuCHcu71zE757gniz4P36m/e/UqtRVLDjyPN3+RxMecxsnXnP+mSWL5/OnrWlSm7OnO2lD6
	elPDv6prOx35sjaVP/3tvUaJpTgj0VCLuag4EQCfIsDrIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DF3GXp9gg6srhSwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsaH
	zRdZC3okKhZ+m8vWwLhDvIuRk0NIQF1i0ZKTbCC2hICJxKljU6BsMYkL99YD2VxANfMZJRb/
	n8AKkmARUJXYtewHexcjBwebgLnE/RlBIGFhAX+Jo/2H2UFsEQE9iSNNK1hBepkFzjNJXOw6
	xQSxTElizb5XLCA2r4CgxMmZT1gglqlKXG5cBRVXk2g9tJYVIi4hMWv6BSibV2JG+1OoejmJ
	aV/XMEPY0hLnZ21ghDl68ffHUHF+iWO3dzCB3AnS++R+MMyY3Zu/QP0oIDH1zEGoVi2Jleuv
	Q9l8EmsWvmWBGbPr1HJmmN77W+aCvcIsoCgxpfshO4StJfHlxz42dG/xCjhK/JnZxzKBUW4W
	ktQsJO2zkLQjq1nAyLKKUTS1ILmgOCm9wkivODG3uDQvXS85P3cTIzg9PVu0g/HfeetDjAIc
	jEo8vBPeeQcLsSaWFVfmHmKU4GBWEuF9newTLMSbklhZlVqUH19UmpNafIgxGRiBE5mlRJPz
	gakzryTe0NjYxMzE1NLEwsDUnDRhJXFe+VtJQUIC6YklqdmpqQWpRTBbmDg4pRoYX8bxitq/
	22LbNDn0Q9k0pk9LkruPclUsXDXxS21i+4Ecnjd/bydc067a+0D/Ueh3oW9Gx0sCrM9n9ryS
	bj6gIety7ef1r1ZHfZQCPT6sWOHQ+LTJXmrXtnsbVDtqZ5wxN/zwf1W1ferT/DNbao5n2a5X
	qT97sEMxxfJ0w/lfq0O6N2m73J7yWYmlOCPRUIu5qDgRAP6WVvGTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3F1aHsW022941

> MyungJoo/Kyungmin,
> 
> Bump. Can we accept this patch please?
> 
> -Saravana

Nack.

Please note that freq_table is also an optional value, which may
be null.

Besides, please be aware that your code is under rcu_read_lock().


Cheers,
MyungJoo.

ps. I'll send a related patch (avoid accessing null but not-an-error
pointer at other sysfs nodes). Thank you for letting me catch such bugs anyway.

> 
> 
> On 04/10/2014 07:54 PM, Saravana Kannan wrote:
> > Some devices use freq_table instead of OPP. For those devices, the
> > available_frequencies file shows up empty. Fix that by using freq_table to
> > generate the available_frequencies data when OPP is not present.
> >
> > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> > ---
> >   drivers/devfreq/devfreq.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index 2042ec3..a715d15 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -912,19 +912,26 @@ static ssize_t available_frequencies_show(struct device *d,
> >   	struct devfreq *df = to_devfreq(d);
> >   	struct device *dev = df->dev.parent;
> >   	struct dev_pm_opp *opp;
> > +	unsigned int i = 0, max_state = df->profile->max_state;
> > +	bool use_opp;
> >   	ssize_t count = 0;
> >   	unsigned long freq = 0;
> >
> >   	rcu_read_lock();
> > +	use_opp = dev_pm_opp_get_opp_count(dev) > 0;
> >   	do {
> > -		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> > -		if (IS_ERR(opp))
> > -			break;
> > +		if (use_opp) {
> > +			opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> > +			if (IS_ERR(opp))
> > +				break;
> > +		} else {
> > +			freq = df->profile->freq_table[i++];
> > +		}
> >
> >   		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> >   				   "%lu ", freq);
> >   		freq++;
> > -	} while (1);
> > +	} while (use_opp || (!use_opp && i < max_state));
> >   	rcu_read_unlock();
> >
> >   	/* Truncate the trailing space */
> >
> 
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
