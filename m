Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbbATErq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:47:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50464 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbATErn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:47:43 -0500
X-AuditID: cbfee68d-f79296d000004278-20-54bdddedae3e
Message-id: <54BDDDED.7050009@samsung.com>
Date: Tue, 20 Jan 2015 13:47:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv8 2/9] devfreq: event: Add resource-managed function for
 devfreq-event device
References: <900879710.1308121421729191415.JavaMail.weblogic@epmlwas04a>
In-reply-to: <900879710.1308121421729191415.JavaMail.weblogic@epmlwas04a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkRPft3b0hBk+/KVg8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	cdmkpOZklqUW6dslcGV8eP2eseAba8WWpzuZGxi/snQxcnJICJhInLi6mxnCFpO4cG89G4gt
	JLCUUeLlMlWYmqXXPwPVcAHFpzNKPL3TyQjhvGaUeLNzBdgkXgEtid6zKxlBbBYBVYllPeuY
	QGw2oPj+FzfApooKhEmsnH4Fql5Q4sfke2C2iICMxNWN21lAhjIL9LJJvFu/COwkYYFkiVWr
	f7NCnOQhcfXIb3YQm1PAU2LPTYhmZgF1iUnzIOqZBeQlNq95C/XORA6JbdsrIA4SkPg2+RBQ
	PQdQXFZi0wGoEkmJgytusExgFJuF5KRZSKbOQjJ1ASPzKkbR1ILkguKk9CJDveLE3OLSvHS9
	5PzcTYzAuD7971nvDsbbB6wPMQpwMCrx8L5YtTdEiDWxrLgy9xCjKdAVE5mlRJPzgckjryTe
	0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRg8lVgG5Wtld
	f994vT/LO/V+qinr62zLBBaVfks+N7Vd0key9vr51pvO3WE1X+z19MX7Iz4aHH83R0fa+Gfy
	v/m37U675RZtTpEP2/66MVdnn1p++f2Zxa8vZZ+6yBwXsPuZb4qUoETSKV+THUdlrlyccvoo
	Z2Hh7Yb9d9Jzv7ibBkuo/TnmqMRSnJFoqMVcVJwIABKBILPmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd23d/eGGBy5IWHxeM1iJouNM9az
	Wky6P4HF4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+TxdLrF5ksbjeuYLN4
	vOItu0Xr3iPsFqt2/WF04PdYM28No8fOWXfZPRbvecnksWlVJ5vH5iX1Hn1bVjF6fN4kF8Ae
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0t5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx48Pr94wF31grtjzdydzA+JWl
	i5GTQ0LARGLp9c/MELaYxIV769m6GLk4hASmM0o8vdPJCOG8ZpR4s3MFWAevgJZE79mVjCA2
	i4CqxLKedUwgNhtQfP+LG2wgtqhAmMTK6Veg6gUlfky+B2aLCMhIXN24nQVkKLNAL5vEu/WL
	wFYLCyRLrFr9mxXEFhLwkLh65Dc7iM0p4Cmx5yZEM7OAusSkeRD1zALyEpvXvGWewCgwC8mO
	WUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOHE8k97BuKrB4hCjAAejEg+v
	w9q9IUKsiWXFlbmHGCU4mJVEeI9eAgrxpiRWVqUW5ccXleakFh9iNAUGwURmKdHkfGBSyyuJ
	NzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYBRc6/xX/ivDPMYnq03f
	HDJdHbfBOrbFzUdir3NIqpgWz6f4/Sc/S67guvtrrqxt48LwmDcHc1u5bqRXPeUO+XfEO2/K
	Mq2fTdoBd11/vebqCp3j1Okzn9P6564Zv090XrArj7J61WtftNJ3muCxKZeEq3uiS26wet1f
	0CBR33SRv6zia3HseiWW4oxEQy3mouJEAPqjxwsyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 01:46 PM, MyungJoo Ham wrote:
>>   
>>  This patch add the resource-managed function for devfreq-event device as
>> following functions. The devm_devfreq_event_add_edev() manages automatically
>> the memory of devfreq-event device using resource management.
>> - devm_devfreq_event_add_edev()
>> - devm_devfreq_event_remove_edev()
>>
>> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.comA
> 
> Reviewed-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> You may merge this patch with 1/9 as well.
> I don't think this is a major change the requires a seperated patch.

OK. I'll merge it. on patch1.

Best Regards,
Chanwoo Choi

