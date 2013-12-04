Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3LDLBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:01:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3LDLBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:01:10 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-43-529f0b745bd5
Message-id: <529F0B75.5040004@samsung.com>
Date: Wed, 04 Dec 2013 20:01:09 +0900
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
In-reply-to: <1386154579.25938.2.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsWyRsSkULeEe36QwcF7QhYHt2pabJyxntVi
	6sMnbBbzj5xjtZi4cjKzxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFlsenyN1WJh2xIWi8u7
	5rBZrD1yl91i6fWLTBYTpq9lsTi84gCTxbqX01ksXh1sY3EQ9lgzbw2jx4LPV9g9JvR/YvTY
	Oesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7QEKLan36NuyitHj8yY5j41zQwN4o7hsUlJz
	MstSi/TtErgyjn95wljwVrpi597LbA2Mm8S6GDk5JARMJHZd/8QOYYtJXLi3nq2LkYtDSGAp
	o8T1nz3MMEUHeyazgthCAosYJS5/5YYoesUo8f54GwtIgldAS+LevRawBhYBVYnXy1aygdhs
	QPH9L26A2aICYRIrp1+BqheU+DH5HpgtImAocXD3diaQocwCm1glLt55B5YQFvCRaDzzhhli
	2ylGiZ7dmxlBEpwCBhJXH58EK2IWUJeYNG8RM4QtL7F5zVuwBgmBOxwSpx/tY4Q4SUDi2+RD
	QA0cQAlZiU0HoF6TlDi44gbLBEaxWUiOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECEwcp/8969vBePOA9SHGZKCVE5mlRJPzgYknryTe0NjMyMLUxNTYyNzSjDRhJXHe
	RQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGq5zOeiWmT73cdOGS6/a3yybekhazo6L
	b+2fnUwu7D/VT7+qVn46I7lJ7F+7TGvrxxqfrHy+q3+4uyXq/v280R3Q16HZ47H72BypIzEO
	9/96akzhX1Pb46s1w+pj0wrmpdHVcX9P7zaqaXxaJLQwRJu/cO7rx8wiTEdUi06cfrfFZaOE
	z54NSizFGYmGWsxFxYkA3GYPVTIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jAd0S7vlBBr0rOSwObtW02DhjPavF
	1IdP2CzmHznHajFx5WRmi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY9Pgaq8XCtiUsFpd3
	zWGzWHvkLrvF0usXmSwmTF/LYnF4xQEmi3Uvp7NYvDrYxuIg7LFm3hpGjwWfr7B7TOj/xOix
	c9Zddo+Vy7+weWxeoeWxaVUnm8er1TNZPe5c2wMUWlLv0bdlFaPH501yHhvnhgbwRjUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAvamkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDj+5QljwVvpip17L7M1MG4S62Lk5JAQ
	MJE42DOZFcIWk7hwbz0biC0ksIhR4vJX7i5GLiD7FaPE++NtLCAJXgEtiXv3WphBbBYBVYnX
	y1aCNbABxfe/uAFmiwqESaycfgWqXlDix+R7YLaIgKHEwd3bmUCGMgtsYpW4eOcdWEJYwEei
	8cwbZohtpxglenZvZgRJcAoYSFx9fBKsiFlAXWLSvEXMELa8xOY1b5knMArMQrJkFpKyWUjK
	FjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQITkvPpHYwrmywOMQowMGoxMObwDkvSIg1
	say4MvcQowQHs5II7xa2+UFCvCmJlVWpRfnxRaU5qcWHGJOBYTCRWUo0OR+YMvNK4g2NTcyM
	LI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbGKx/DEjSktB/JspdlKlDKn
	/F16KLj3bUpg6zGbTYtVuJIeLd6/cEaj95KguIqHjwyXb2f0X39Iysai+8OHmSnnrll8mVv5
	MP/zB7HODVOnh/c67tjUfHw6U8Wu3Sa7E2Uce1Y2Tw3fmPJtt/GS3AT24q2+S1S/v798oXqT
	u2r1n6X+sU7HOyYrsRRnJBpqMRcVJwIAZ6P7dI8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 07:56 PM, Krzysztof Kozlowski wrote:
> On Wed, 2013-12-04 at 19:50 +0900, Chanwoo Choi wrote:
>> Hi Krzysztof,
>>
>> On 12/04/2013 07:40 PM, Krzysztof Kozlowski wrote:
>>> Add document describing device tree bindings for MAX14577 MFD driver.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++++++++++++++++++++
>>>  1 file changed, 48 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
>>> new file mode 100644
>>> index 000000000000..f4fd16360b6b
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
>>> @@ -0,0 +1,48 @@
>>> +MAXIM MAX14577 multi-function device
>>> +
>>> +MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
>>> +Battery Charger and SFOUT LDO output for powering USB devices. It is
>>> +interfaced to host controller using I2C.
>>> +
>>> +Required properties:
>>> +- compatible : Must be "maxim,max14577".
>>> +- reg : I2C slave address for the max14577 chip.
>>> +- interrupts : IRQ line for the max14577 chip.
>>> +- interrupt-parent :  The parent interrupt controller.
>>> +
>>> +Optional nodes:
>>> +- regulators :
>>> +  Required child node properties:
>>> +  - compatible : "maxim,max14577-regulator"
>>> +
>>> +  Optional child nodes:
>>> +    Each child node representing a regulator, following standard regulator
>>> +    bindings. Valid names for a regulator are: "CHARGER" and "SAFEOUT".
>>> +    The SAFEOUT is a constant voltage regulator so there is no need to specify
>>> +    voltages for it.
>>> +
>>> +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>>> +
>>> +Example:
>>> +	max14577@25 {
>>> +		compatible = "maxim,max14577";
>>> +		reg = <0x25>;
>>> +		interrupt-parent = <&gpx1>;
>>> +		interrupts = <5 0>;
>>> +
>>> +		regulators {
>>> +			compatible = "maxim,max14577-regulator";
>>> +
>>> +			safeout_reg: safeout@1 {
>>> +				regulator-compatible = "SAFEOUT";
>>> +				regulator-name = "SAFEOUT";
>>> +			};
>>> +			charger_reg: charger@0 {
>>> +				regulator-compatible = "CHARGER";
>>> +				regulator-name = "CHARGER";
>>> +				regulator-min-microamp = <90000>;
>>> +				regulator-max-microamp = <950000>;
>>> +				regulator-boot-on;
>>> +			};
>>> +		};
>>
>> I prefer to add dt data about max14577-muic on following:
>> If extcon consumer driver need to use muic device, dts should provide following dt data.
>>
>> 		muic: max14577-muic {
>> 			compatible = "maxim, max14577-muic";
>> 		};
>>> +	};
>>>
>> For example,
>> If fuel-gauge want to use extcon subsystem, dt data of fuel-gauge add 'extcon' property as following:
>>
>> 	fuel-gague@ {
>> 		compatible = "...";
>> 		extcon = <&muic>;
>> 	}
>>
> Hi,
> 
> The extcon driver itself does not use the binding. It is only needed for
> consumers. Is it a common practice to add to documentation such notice
> for consumers only?

As you comment, It is only for extcon consumer.
But extcon provider driver always is operated with extcon consumer driver.
If dts file don't support upper dt data about extcon provider driver,
all of extcon consumer drivers could not use extcon subsystem.

I thinks it is common dt data for muic device.

Thanks,
Chanwoo Choi





