Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaFRGUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:20:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14665 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbaFRGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:20:14 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-6a-53a12f9a718d
Message-id: <53A12F9A.4060603@samsung.com>
Date: Wed, 18 Jun 2014 15:20:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: jic23@kernel.org, My self <ch.naveen@samsung.com>, t.figa@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-4-git-send-email-cw00.choi@samsung.com>
 <CAHfPSqBepO+73vLyJJox1fP=0-F5KSE3uyjh-HXYXkHRLpw0QA@mail.gmail.com>
In-reply-to: <CAHfPSqBepO+73vLyJJox1fP=0-F5KSE3uyjh-HXYXkHRLpw0QA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSojtbf2GwwaY+Jou7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hksWjbf2aL
	CdPXsli8vTOdxaJ17xF2i5N/ehkt1s94zeIg6LFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoe
	m1Z1snncubaHzaNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgydtx7zVhwkaVi5/vHLA2Mj5i7
	GDk5JARMJDo27mWDsMUkLtxbD2RzcQgJLGWUOPv4GBNM0bO2VrAiIYFFjBIXlyhCFL1mlOhb
	1QNWxCugJTF10newqSwCqhIL++eCNbABxfe/uAFmiwqESaycfoUFol5Q4sfke2C2iICRxMwH
	CxlBbGaBq8wSjxaA1QsLxEqcPnmPHWLZCUaJ1893s4IkOAWCJR5s2M8G0aAuMWneImYIW15i
	85q3zCANEgJbOCSmXWqHukhA4tvkQ0DbOIASshKbDkC9LylxcMUNlgmMYrOQ3DQLydhZSMYu
	YGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRGYAk7/e9a7g/H2AetDjMlAKycyS4km5wNT
	SF5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MN7/
	p/d7ypzjE7fYG89t622svP6P1S9qy/LXL3Vn+6YtlEu7ml95+tfB2AleWXek2hr/xat5pxyf
	Mu/zH4myeY8/shWEmLvdX7jb7sUZ73luQu39fPedOd93uK73YmVf+Uzo81sWN9UL17769y7/
	/3Kh3xNOOy4L9aOMh4p9K+9zv9xx+s862wwlluKMREMt5qLiRACyzNHwFwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd1Z+guDDf7cMrW4+/wwo8X8I+dY
	LfrfLGS1OPdqJaPFg6ZVTBa9C66yWSxsW8JiMe/IOxaLy7vmsFnMOL+PyWLp9YtMFou2/We2
	mDB9LYvF2zvTWSxa9x5htzj5p5fRYv2M1ywOgh5r5q1h9Ljc18vksXPWXXaPlcu/sHlsXqHl
	sWlVJ5vHnWt72Dz6tqxi9Pi8SS6AM6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ
	0sJcSSEvMTfVVsnFJ0DXLTMH6BklhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGENY8aOe68ZCy6yVOx8/5ilgfERcxcjJ4eEgInEs7ZWNghbTOLCvfVgtpDAIkaJi0sUuxi5
	gOzXjBJ9q3qYQBK8AloSUyd9B2tmEVCVWNg/F6yBDSi+/8UNMFtUIExi5fQrLBD1ghI/Jt8D
	s0UEjCRmPljICGIzC1xllni0AKxeWCBW4vTJe+wQy04wSrx+vpsVJMEpECzxYMN+NogGdYlJ
	8xYxQ9jyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OME8k9rBuLLB4hCjAAejEg8vR+6CYCHWxLLiytxDjBIczEoivNx6C4OFeFMSK6tSi/Lji0pz
	UosPMSYDg2Ais5Rocj4w+eWVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA+O+9VqOwqtihQuvxRTsD3i7KtyGJXfp43aW3P18nQ93mtVvbvG8eaeEjd1K76r/
	3glhjgpPTyjMen3sWZWyfP/zafNl7x+RW9753bPzyrNt8tW6e194bupfpyH2QzhLdvlEZdmq
	kCVCEft31kYbXk9oU7XVfzZhwYQHW2MYOn/P+fn+Eu8se0UlluKMREMt5qLiRAAbPquRdAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 06/18/2014 03:12 PM, Naveen Krishna Ch wrote:
> Hello Chanwoo,
> 
> On 18 June 2014 07:51, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
>> special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Changes look good to me.
> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi



