Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3LDKuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:50:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8305 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3LDKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:50:06 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-b9-529f08dccedd
Message-id: <529F08DD.2090005@samsung.com>
Date: Wed, 04 Dec 2013 19:50:05 +0900
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
In-reply-to: <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkWPcOx/wgg327VC0ObtW02DhjPavF
	1IdP2CzmHznHajFx5WRmi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY9Pgaq8XCtiUsFpd3
	zWGzWHvkLrvF0usXmSwmTF/LYnF4xQEmi3Uvp7NYvDrYxuIg7LFm3hpGjwWfr7B7TOj/xOix
	c9Zddo+Vy7+weWxeoeWxaVUnm8er1TNZPe5c2wMUWlLv0bdlFaPH501yHhvnhgbwRnHZpKTm
	ZJalFunbJXBlTH77n6nguWjF/0/9bA2MKwW7GDk5JARMJP5O6mCFsMUkLtxbz9bFyMUhJLCU
	UaKz/yA7TNH55tdsILaQwHRGiZ7VHhBFrxglfnZsYwZJ8ApoSUy5fIQFxGYRUJVoOH0MLM4G
	FN//4gZYs6hAmMTK6VdYIOoFJX5MvgdmiwgYShzcvZ0JZCizwCZWiYt33oElhAV8JBrPvGGG
	2NbKKDHhxikgh4ODU8BDYu6CNJAaZgEdif2t09ggbHmJzWvegtVLCNzhkDi4cz7URQIS3yYf
	YgHplRCQldh0gBniM0mJgytusExgFJuF5KZZSMbOQjJ2ASPzKkbR1ILkguKk9CJTveLE3OLS
	vHS95PzcTYzAtHH637OJOxjvH7A+xJgMtHIis5Rocj4w7eSVxBsamxlZmJqYGhuZW5qRJqwk
	zpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PsgsSbkoffpwqlOOx582Kp+tuFfcpN
	8w1/GphfCLm/205Pp5mXw9dW6c1rn8MacWrCeQYCb4T9vSe1FQaIfJeYdMnN8Z2MdKfJ5D93
	jv5udTzSeyZl09sVSQXfJ3P8WZp7iqHs0MrQrYclNbrbN8xUcGTMfy+3v0Xnmr6XOAdH48z6
	WyZP9iqxFGckGmoxFxUnAgBrFQy4MQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd07HPODDNYtkLY4uFXTYuOM9awW
	Ux8+YbOYf+Qcq8XElZOZLc69Wslo8fqFocXZpjfsFve/HmW0+Halg8li0+NrrBYL25awWFze
	NYfNYu2Ru+wWS69fZLKYMH0ti8XhFQeYLNa9nM5i8epgG4uDsMeaeWsYPRZ8vsLuMaH/E6PH
	zll32T1WLv/C5rF5hZbHplWdbB6vVs9k9bhzbQ9QaEm9R9+WVYwenzfJeWycGxrAG9XAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KaSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPy2/9MBc9FK/5/6mdrYFwp2MXIySEh
	YCJxvvk1G4QtJnHh3nowW0hgOqNEz2qPLkYuIPsVo8TPjm3MIAleAS2JKZePsIDYLAKqEg2n
	j4HF2YDi+1/cAGsWFQiTWDn9CgtEvaDEj8n3wGwRAUOJg7u3M4EMZRbYxCpx8c47sISwgI9E
	45k3zBDbWhklJtw4BeRwcHAKeEjMXZAGUsMsoCOxv3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaS
	sgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPSM6kdjCsbLA4xCnAwKvHwJnDOCxJi
	TSwrrsw9xCjBwawkwruFbX6QEG9KYmVValF+fFFpTmrxIcZkYBBMZJYSTc4HJsy8knhDYxMz
	I0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDkzV1x+XnVYvU9N05HfflZ
	wCifPfHPpPqjS1geH+K2u/LiXc4aP8W0zFnTFk+6LRr44X/znxWL7FlZY5v3ZfLWLrpwMk1v
	6ox+oYcafS/7dQ816EWzd+yK+xevMFWlTs/0Uze72pQrfT+6Fk7m9v2fpx7v9d7dSnNl3vK7
	DAIaSxRdhVsZdSWVWIozEg21mIuKEwFqK9JijgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 12/04/2013 07:40 PM, Krzysztof Kozlowski wrote:
> Add document describing device tree bindings for MAX14577 MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> new file mode 100644
> index 000000000000..f4fd16360b6b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> @@ -0,0 +1,48 @@
> +MAXIM MAX14577 multi-function device
> +
> +MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
> +Battery Charger and SFOUT LDO output for powering USB devices. It is
> +interfaced to host controller using I2C.
> +
> +Required properties:
> +- compatible : Must be "maxim,max14577".
> +- reg : I2C slave address for the max14577 chip.
> +- interrupts : IRQ line for the max14577 chip.
> +- interrupt-parent :  The parent interrupt controller.
> +
> +Optional nodes:
> +- regulators :
> +  Required child node properties:
> +  - compatible : "maxim,max14577-regulator"
> +
> +  Optional child nodes:
> +    Each child node representing a regulator, following standard regulator
> +    bindings. Valid names for a regulator are: "CHARGER" and "SAFEOUT".
> +    The SAFEOUT is a constant voltage regulator so there is no need to specify
> +    voltages for it.
> +
> +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +Example:
> +	max14577@25 {
> +		compatible = "maxim,max14577";
> +		reg = <0x25>;
> +		interrupt-parent = <&gpx1>;
> +		interrupts = <5 0>;
> +
> +		regulators {
> +			compatible = "maxim,max14577-regulator";
> +
> +			safeout_reg: safeout@1 {
> +				regulator-compatible = "SAFEOUT";
> +				regulator-name = "SAFEOUT";
> +			};
> +			charger_reg: charger@0 {
> +				regulator-compatible = "CHARGER";
> +				regulator-name = "CHARGER";
> +				regulator-min-microamp = <90000>;
> +				regulator-max-microamp = <950000>;
> +				regulator-boot-on;
> +			};
> +		};

I prefer to add dt data about max14577-muic on following:
If extcon consumer driver need to use muic device, dts should provide following dt data.

		muic: max14577-muic {
			compatible = "maxim, max14577-muic";
		};
> +	};
> 

For example,
If fuel-gauge want to use extcon subsystem, dt data of fuel-gauge add 'extcon' property as following:

	fuel-gague@ {
		compatible = "...";
		extcon = <&muic>;
	}


Thanks,
Chanwoo Choi







