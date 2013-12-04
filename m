Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3LDLJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:09:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10986 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3LDLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:09:18 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-66-529f0d5d146b
Message-id: <529F0D5E.4060202@samsung.com>
Date: Wed, 04 Dec 2013 20:09:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
 <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
 <529F08DD.2090005@samsung.com> <1386154579.25938.2.camel@AMDC1943>
 <529F0B75.5040004@samsung.com> <1386155011.25938.4.camel@AMDC1943>
In-reply-to: <1386155011.25938.4.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkSDeWd36QwaTTYhYHt2pabJyxntVi
	6sMnbBbzj5xjtZi4cjKzxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFlsenyN1WJh2xIWi8u7
	5rBZrD1yl91i6fWLTBYTpq9lsTi84gCTxbqX01ksXh1sY3EQ9lgzbw2jx4LPV9g9JvR/YvTY
	Oesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7QEKLan36NuyitHj8yY5j41zQwN4o7hsUlJz
	MstSi/TtErgy7q0/z1SwiaviTO985gbG6RxdjJwcEgImEr8bJzFC2GISF+6tZ+ti5OAQEljK
	KPGhHKbkz8pHQGEuoPAiRomXl/ZDOa8YJW7+OMYCUsUroCWxetossEEsAqoSWxc3gtlsQPH9
	L26wgdiiAmESK6dfgaoXlPgx+R6YLSJgKHFw93YmkKHMAptYJS7eeQeWEBbwkWg884YZYls/
	k8TUl3+ZQRKcAgYSE/uOgBUxC6hLTJq3iBnClpfYvOYtWIOEwA0Oia7VK1ghThKQ+Db5EAvI
	bxICshKbDjBD/CYpcXDFDZYJjGKzkBw1C8nYWUjGLmBkXsUomlqQXFCclF5kqlecmFtcmpeu
	l5yfu4kRmDZO/3s2cQfj/QPWhxiTgVZOZJYSTc4Hpp28knhDYzMjC1MTU2Mjc0sz0oSVxHnT
	HyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA8NiFBzHLrmn/aWydG+Xr//nphh4/C/cu3
	vc4suJhaoCm188J/F9f8Ocffnpm8hMEj5/J1zY0p9sfc5ymErq6e2JX8fF5vEcdkt7up7usv
	2+0PvcMktPqn4uljGe4mU9um6HqU8+n/aBB52cm5S9nV22J5qYZURP58Q9lvBYEbHQ5kJGW+
	t9qkxFKckWioxVxUnAgAaJLPczEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t9jAd1Y3vlBBl1zeC0ObtW02DhjPavF
	1IdP2CzmHznHajFx5WRmi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY9Pgaq8XCtiUsFpd3
	zWGzWHvkLrvF0usXmSwmTF/LYnF4xQEmi3Uvp7NYvDrYxuIg7LFm3hpGjwWfr7B7TOj/xOix
	c9Zddo+Vy7+weWxeoeWxaVUnm8er1TNZPe5c2wMUWlLv0bdlFaPH501yHhvnhgbwRjUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAvamkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLi3/jxTwSauijO985kbGKdzdDFyckgI
	mEj8WfmIDcIWk7hwbz2QzcUhJLCIUeLlpf1QzitGiZs/jrGAVPEKaEmsnjaLEcRmEVCV2Lq4
	EcxmA4rvf3EDbJKoQJjEyulXoOoFJX5MvgdmiwgYShzcvZ0JZCizwCZWiYt33oElhAV8JBrP
	vGGG2NbPJDH15V9mkASngIHExL4jYEXMAuoSk+YtYoaw5SU2r3nLPIFRYBaSJbOQlM1CUraA
	kXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBieia9g3FVg8UhRgEORiUe3gTOeUFCrIll
	xZW5hxglOJiVRHi3sM0PEuJNSaysSi3Kjy8qzUktPsSYDAyDicxSosn5wKSZVxJvaGxiZmRp
	ZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2McUccav9axySvTf6dYVAdf2zH
	g9sC9woE46LDjv988Fi98pFWI98M+6MdG0Mf/f9i53opt2Bijrdzwa/bq0yPiy17aRwkJuHy
	5mGV1SQh5R1qz/aLmekwxh45Iu/xaeMxv4mxTzNPrFy3aDd/StzVOc7HFJcveapU5KtscOxW
	yM7LX1tZMqZuVmIpzkg01GIuKk4EAHV6IQ+QAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 08:03 PM, Krzysztof Kozlowski wrote:
> On Wed, 2013-12-04 at 20:01 +0900, Chanwoo Choi wrote:
>> On 12/04/2013 07:56 PM, Krzysztof Kozlowski wrote:
>>> On Wed, 2013-12-04 at 19:50 +0900, Chanwoo Choi wrote:
> (...)
>>>>
>>>> I prefer to add dt data about max14577-muic on following:
>>>> If extcon consumer driver need to use muic device, dts should provide following dt data.
>>>>
>>>> 		muic: max14577-muic {
>>>> 			compatible = "maxim, max14577-muic";
>>>> 		};
>>>>> +	};
>>>>>
>>>> For example,
>>>> If fuel-gauge want to use extcon subsystem, dt data of fuel-gauge add 'extcon' property as following:
>>>>
>>>> 	fuel-gague@ {
>>>> 		compatible = "...";
>>>> 		extcon = <&muic>;
>>>> 	}
>>>>
>>> Hi,
>>>
>>> The extcon driver itself does not use the binding. It is only needed for
>>> consumers. Is it a common practice to add to documentation such notice
>>> for consumers only?
>>
>> As you comment, It is only for extcon consumer.
>> But extcon provider driver always is operated with extcon consumer driver.
>> If dts file don't support upper dt data about extcon provider driver,
>> all of extcon consumer drivers could not use extcon subsystem.
>>
>> I thinks it is common dt data for muic device.
> 
> OK, I'll add it.
> 

Thanks,

Best Regards,
Chanwoo Choi

