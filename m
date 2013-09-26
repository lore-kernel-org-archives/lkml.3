Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3IZIA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:00:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47820 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3IZIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:00:28 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-b3-5243e99ae4d9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Milo Kim'" <milo.kim@ti.com>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
 <003701ceba8d$1f1c5a70$5d550f50$%han@samsung.com>
 <CAK9yfHxPo6p1g15nPPPM3whpv0fwzS-za3iTTBmmK609pmZLtw@mail.gmail.com>
In-reply-to: <CAK9yfHxPo6p1g15nPPPM3whpv0fwzS-za3iTTBmmK609pmZLtw@mail.gmail.com>
Subject: Re: From 782c15faac0a93cdac43b212073081707f669272 Mon Sep 17 00:00:00
 2001
Date: Thu, 26 Sep 2013 17:00:26 +0900
Message-id: <004001ceba8e$75a84f10$60f8ed30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jbWWjldzX+RNTziMYORbrDz/YwAAFvjA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zfd1ZL52DDGZOULeY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWCxO/ulldGDz2DnrLrvHplWdbB53ru1h8+jbsorR4/iN7UwenzfJ
	BbBFcdmkpOZklqUW6dslcGUsXzGPvWAuS8WljUdZGhh3MHcxcnJICJhIPJvSxQZhi0lcuLce
	yObiEBJYxijRfnUtC0zR7X9LmCES0xkldj1+wA7h/GKU+PNlLytIFZuAmsSXL4fZQWwRAR2J
	FbvWMoEUMQvsZJS4tG4DE0THDkaJ/49/gVVxCgRLPHm8CuwQYYFQiZUfNoHFWQRUJa61vmUE
	sXkFbCVud3SzQtiCEj8m3wO7iVlAS2L9zuNMELa8xOY1b4HmcADdqi7x6K8uxBFGEt//H4Eq
	EZHY9+IdI8gNEgJv2SVO/vrIBrFLQOLb5EMsEL2yEpsOQMNFUuLgihssExglZiHZPAvJ5llI
	Ns9CsmIBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJAY7t3BePuA9SHGZKD1E5mlRJPz
	gSkgryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	B8qizfzdnR6arVwTLf31q1Nu5A/5oIZfcncORC18brOBr3I9axWjc96OXjmbX91rHl70Ya3J
	79zuxBlx9NTCT9Vqe/bIHfdVf3OijDs3c2df/YyjvBULPRqiUtNcbznFfJH/7SL8ustvl4Gd
	AfcOhUK5wyd4blU+uudyrfP7k1t7q7323pqpxFKckWioxVxUnAgATf9rYfcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd1ZL52DDNoWKVtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LBYn//QyOrB57Jx1l91j06pONo871/awefRtWcXocfzGdiaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmLF8xj71gLkvFpY1HWRoY
	dzB3MXJySAiYSNz+twTKFpO4cG89WxcjF4eQwHRGiV2PH7BDOL8YJf582csKUsUmoCbx5cth
	dhBbREBHYsWutUwgRcwCOxklLq3bwATRsYNR4v/jX2BVnALBEk8erwLbISwQKrHywyawOIuA
	qsS11reMIDavgK3E7Y5uVghbUOLH5HssIDazgJbE+p3HmSBseYnNa94CzeEAulVd4tFfXYgj
	jCS+/z8CVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjOEE8k97BuKrB4hCjAAejEg/vBWbnICHWxLLiytxDjBIczEoivN+MgEK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0xeeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXAKFa5xGTLhJlsJ7wXFzqz3VxnXe9ZGvylV3xrwux93NkyTpUZ2+dIcaz/
	X1eWv2WO7Mvm8KY/h5N8dWJmLir4xn7ZQSHaLGL+bJ+n6jdkj55eZ7on/Ipn2w2Gtz+ze13l
	v8hMUV+jm+8okaUTN7819K9BNeepKL7FH5xb997PuvjqqvxH19Q0JZbijERDLeai4kQAJY45
	71QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 4:55 PM, Sachin Kamat wrote:
> On 26 September 2013 13:20, Jingoo Han <jg1.han@samsung.com> wrote:
> > Use devm_regulator_register() to make cleanup paths simpler,
> > and remove unnecessary remove().
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Patch title looks to be corrupted?

Sorry, it's my fault.
The patch title is fixed and re-sent as below:
'[PATCH V3 07/14] regulator: lp8788-ldo: use devm_regulator_register()'
Thank you for caring. :-)

Best regards,
Jingoo Han

