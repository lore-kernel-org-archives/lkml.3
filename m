Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaEHKCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:02:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaEHKCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:02:20 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-94-536b562adda6
Date: Thu, 08 May 2014 10:02:18 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v2] PM / devfreq: Use freq_table for
 available_frequencies
To: Saravana Kannan <skannan@codeaurora.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140508100209287@myungjoo.ham
Msgkey: 20140508100209287@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140508100209287@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30733097.432311399543337408.JavaMail.weblogic@epv6ml09>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSoKsVlh1scGuxpcXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mo4++ITS8E12YrGLwYNjB9kuhg5OYQE1CUWLTnJBmJLCJhI/Fu5
	khnCFpO4cG89UJwLqGYpo8TVaT0sMEV/Du5ngkjMYZTYsGQJWIJFQEViRks7YxcjBwebgJ7E
	zM/JIGFhgSCJLU++gZWIAIWPNK1gBellFjjPJHGx6xQTxBVKEmv2vQIr4hUQlDg58wnUMlWJ
	JadPQcXVJGauX88IEZeQmDX9AiuEzSsxo/0pVL2cxLSva6A+kJY4P2sDI8w3i78/horzSxy7
	vYMJ5E6Q3if3g2HG7N78BRoQAhJTzxyEatWSeLVkHtQqPok1C9+ywIzZdWo5M0zv/S1zwV5h
	FlCUmNL9kB3C1pL48mMfG6q3OIBsF4lVZ5MmMCrPQpKZhaR7FpJuZDULGFlWMYqmFiQXFCel
	FxnpFSfmFpfmpesl5+duYgQmhdP/nvXtYLx5wPoQYzIwRiYyS4km5wOTSl5JvKGxmZGFqYmp
	sZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYFz8S9I6pFxlmv3/A/e2
	fZhQvsuWp1ZBJKX0g/iuhrkFtW4RnpcFGplffsvftf2O8SS738rxHBJOG3S3GYZWLp4isfYq
	F6Pxgv87Uj0Fr2Tv7dA0ZfEP7rGfq/j23Zwvq2dFrZPUTG1nXCFhc1O4cIr89k3JexIKIhkS
	l6ps9rjiu9VTc79djhJLcUaioRZzUXEiAKQKpE8gAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tXl2tsOxgg+M75S0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsbZ
	F59YCq7JVjR+MWhg/CDTxcjJISSgLrFoyUk2EFtCwETiz8H9TBC2mMSFe+uB4lxANXMYJTYs
	WcICkmARUJGY0dLO2MXIwcEmoCcx83MySFhYIEhiy5NvYCUiQOEjTStYQXqZBc4zSVzsOsUE
	sUxJYs2+V2BFvAKCEidnPmGBWKYqseT0Kai4msTM9esZIeISErOmX2CFsHklZrQ/haqXk5j2
	dQ0zhC0tcX7WBkaYoxd/fwwV55c4dnsHE8idIL1P7gfDjNm9+QvUvwISU88chGrVkni1ZB7U
	Kj6JNQvfssCM2XVqOTNM7/0tc8FeYRZQlJjS/ZAdwtaS+PJjHxuqtziAbBeJVWeTJjDKzUKS
	mYWkexaSbmQ1CxhZVjGKphYkFxQnpVeY6BUn5haX5qXrJefnbmIEp6ZnS3YwNlywPsQowMGo
	xMOb4ZwVLMSaWFZcmXuIUYKDWUmEl8c/O1iINyWxsiq1KD++qDQntfgQYzIw/iYyS4km5wPT
	Zl5JvKGxsYmZiamliYWBqTlpwkrivAtuJQUJCaQnlqRmp6YWpBbBbGHi4JRqYOyLz1Nbd0v/
	6zc5vzXzRfMPTDK5dKZ8U3OftolnnEfnf8fHXe37uxqv/1h83bD3zI0tf559bhfKX/Gk857v
	w3+/pzmEVxd8bJs7YeGklbvkA44Lr8rMXf7lXWT/qlVfV3xwm5bN+nWV9qbUk7rS9z+9NTrK
	LegTGr51gqDzvsPVEc5zXved2KGmxFKckWioxVxUnAgAQe8BmZEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s48A2X2N026214

> On 04/29/2014 01:00 PM, Saravana Kannan wrote:
> > On 04/27/2014 06:41 PM, MyungJoo Ham wrote:
> >> You are hereby changing the semmantics of the original
> >> available_frequencies node.
> >>
> >> When a frequency/voltage pair has been disabled (opp_disable), probably
> >> by opp_disable(), the frequency is no more "available".
> >> However, when the driver author supplied freq_table as well as OPP
> >> in order to see the statistics, the node will behave differently.
> >>
> >> Please do not affect the current users as long as it does not give
> >> additional benefit or fix a bug.
> > 
> > I was actually trying to stick with the semantics as it was documented.
> > The documentation for this file says it'll show frequencies that are not
> > allowed by the current min/max settings either. To me, an OPP disable
> > seems similar to some frequencies "disabled" by min/max settings.
> > 
> > Giving preference to OPP is not a hard change to do, but it seems to go
> > againsts the documented semantics.
> > 
> > Thoughts?
> 
> I'll send out another patch like you wanted -- with OPP being given
> preference over freq_table when listing frequencies.
> 
> But I would still like to hear your thoughts. As of today, there's no
> clean way to get the complete list of available frequencies that would
> give a consistent output irrespective of the temporary limits/conditions
> imposed by thermal, current limiting, etc. The round about way is to cat
> trans_stat and parse the frequencies from that.
> 
> That's why I was trying to give preference to freq_table.
> 
> Thanks,
> Saravana

The node, available_frequencies, was suggested before freq_table concept.
At that time, available_frequencies was supposed to show the list of
available OPP lists for those who use OPP for devfreq device, excluding
those disabled by OPP. (OPP lists are external to devfreq and devfreq's
min/max are internal to devfreq)

Locally, this node has been used to debug the behavior of a devfreq device.
With min/max nodes, we know the range while we cannot (easily at shell)
see which OPP points are available at the moment, where we have been able
to use available_frequencies.

We do not want to lose such capavility as long as we do not have OPP sysfs
automatically assigned to any OPP lists. If I remember correctly, we don't
have it, yet.


A. I want to minimize semantics changes in sysfs. Adding another without
interfering with previous usage is ok.
B. (more importantly) I don't want to lose the debugging capabilities.


Cheers,
MyungJoo.

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
