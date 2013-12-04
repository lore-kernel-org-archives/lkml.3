Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3LDK40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:56:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30737 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3LDK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:56:23 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-b1-529f0a549881
Message-id: <1386154579.25938.2.camel@AMDC1943>
Subject: Re: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
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
Date: Wed, 04 Dec 2013 11:56:19 +0100
In-reply-to: <529F08DD.2090005@samsung.com>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
 <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
 <529F08DD.2090005@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t/xy7ohXPODDHofGlsc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPdqJaPF2aY37Bb3vx5ltPh2pYPJYtPja6wWC9uWsFhc
	3jWHzWLtkbvsFkuvX2SymDB9LYvF4RUHmCzWvZzOYvHqYBuLg7DHmnlrGD0WfL7C7jGh/xOj
	x85Zd9k9Vi7/wuaxeYWWx6ZVnWwer1bPZPW4c20PUGhJvUffllWMHp83yXlsnBsawBvFZZOS
	mpNZllqkb5fAlbH65lumghcSFS8PL2dsYNwm3MXIySEhYCKx+vAENghbTOLCvfVANheHkMBS
	RolJt7cxQTifGSVOT/vCClLFK6AvMenQS0YQW1jAR6LxzBtmEJtNwFhi8/IlYJNEBDQkZv69
	wgjSzCywiVXi4p13LCAJFgFViZY3K8CKOAW0JXad7oJat4xR4vOBHWBFzALqEpPmLWKGuElJ
	Ynd7JztEXF5i85q3zBBXCEr8mHyPZQKjwCwkLbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJu
	cWleul5yfu4mRkisftnBuPiY1SFGAQ5GJR5eDvZ5QUKsiWXFlbmHGCU4mJVEeLewzQ8S4k1J
	rKxKLcqPLyrNSS0+xMjEwSnVwJixdIfU0w+rVvX732TY4Gus4nMlba6B6J3vssZXZq7fs39a
	ccmz7EVuWRbWN9xmR62aYWckGfyh8p3k0i3XljjlesjK2a7+dqM5QtXgT43Owe1ztfcr2THf
	KPzqXedo9LjooXHRhfQZa/dfm94hu/TCOq/KTzH7jh1eK13mcEW7JtBqVrD6bXUlluKMREMt
	5qLiRACf4JlZswIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 19:50 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> On 12/04/2013 07:40 PM, Krzysztof Kozlowski wrote:
> > Add document describing device tree bindings for MAX14577 MFD driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> > new file mode 100644
> > index 000000000000..f4fd16360b6b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> > @@ -0,0 +1,48 @@
> > +MAXIM MAX14577 multi-function device
> > +
> > +MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
> > +Battery Charger and SFOUT LDO output for powering USB devices. It is
> > +interfaced to host controller using I2C.
> > +
> > +Required properties:
> > +- compatible : Must be "maxim,max14577".
> > +- reg : I2C slave address for the max14577 chip.
> > +- interrupts : IRQ line for the max14577 chip.
> > +- interrupt-parent :  The parent interrupt controller.
> > +
> > +Optional nodes:
> > +- regulators :
> > +  Required child node properties:
> > +  - compatible : "maxim,max14577-regulator"
> > +
> > +  Optional child nodes:
> > +    Each child node representing a regulator, following standard regulator
> > +    bindings. Valid names for a regulator are: "CHARGER" and "SAFEOUT".
> > +    The SAFEOUT is a constant voltage regulator so there is no need to specify
> > +    voltages for it.
> > +
> > +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> > +
> > +Example:
> > +	max14577@25 {
> > +		compatible = "maxim,max14577";
> > +		reg = <0x25>;
> > +		interrupt-parent = <&gpx1>;
> > +		interrupts = <5 0>;
> > +
> > +		regulators {
> > +			compatible = "maxim,max14577-regulator";
> > +
> > +			safeout_reg: safeout@1 {
> > +				regulator-compatible = "SAFEOUT";
> > +				regulator-name = "SAFEOUT";
> > +			};
> > +			charger_reg: charger@0 {
> > +				regulator-compatible = "CHARGER";
> > +				regulator-name = "CHARGER";
> > +				regulator-min-microamp = <90000>;
> > +				regulator-max-microamp = <950000>;
> > +				regulator-boot-on;
> > +			};
> > +		};
> 
> I prefer to add dt data about max14577-muic on following:
> If extcon consumer driver need to use muic device, dts should provide following dt data.
> 
> 		muic: max14577-muic {
> 			compatible = "maxim, max14577-muic";
> 		};
> > +	};
> > 
> For example,
> If fuel-gauge want to use extcon subsystem, dt data of fuel-gauge add 'extcon' property as following:
> 
> 	fuel-gague@ {
> 		compatible = "...";
> 		extcon = <&muic>;
> 	}
> 
Hi,

The extcon driver itself does not use the binding. It is only needed for
consumers. Is it a common practice to add to documentation such notice
for consumers only?

Best regards,
Krzysztof


