Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaGCLok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:44:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50452 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaGCLoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:44:38 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-86-53b54222797e
Message-id: <1404387874.21377.8.camel@AMDC1943>
Subject: Re: [RESEND PATCH 5/5] devicetree: mfd: max14577: Add device tree
 bindings document
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Thu, 03 Jul 2014 13:44:34 +0200
In-reply-to: <20140703113236.GA28504@leverpostej>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
 <1404198121-22989-6-git-send-email-k.kozlowski@samsung.com>
 <20140703113236.GA28504@leverpostej>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4NV0lp63BBsvuCFpsnLGe1WLqwyds
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdmmN+wW978eZbT4dqWDyeLyrjlsFmuP3GW3
	WHr9IpPFhOlrWSxa9x5htzjdzWqxfsZrFgdBjzXz1jB6XO7rZfLYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnr0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxo+/f5kLTolWNGwNa2Dc
	JNjFyMkhIWAicXTWfRYIW0ziwr31bF2MXBxCAksZJaYuvMsC4XxmlDg+pZUdpIpXQF/ixeUO
	ZhBbWCBOYvX6n2BxNgFjic3Ll7CB2CIC6hI9u76ANTML7GaVONo8iRUkwSKgKvHy1RUmEJtT
	wFDi4I4HYLaQwBpGif6z/CA2M1DzpHmLmCFOUpaYt/8YE8RiQYkfk++xQNTIS2xe85Z5AqPA
	LCQts5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSNx93cG49JjVIUYBDkYl
	Ht4X+puChVgTy4orcw8xSnAwK4nwttpsDRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAWPj7sTXL
	kfkvdjDsu8hm9dDUwlYwyWX3FKF9mldX3P/n3HVTn9Om+d+G22tvXM0pYv5+N6vAfIGziXPt
	9IXq6Scvv365r+8pL28Om2TZTn7+w0K3t+WEehdaWp7MeiPXVsGS9S3ZZ+/5G21vnncWnvwy
	3y/GgycgxjfIgtV/zZWnZs9m7WdeqMRSnJFoqMVcVJwIAPjGIfiZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-07-03 at 12:32 +0100, Mark Rutland wrote:
> Hi,
> 
> On Tue, Jul 01, 2014 at 08:02:00AM +0100, Krzysztof Kozlowski wrote:
> > Add document describing device tree bindings for MAX14577 MFD
> > drivers: MFD core, extcon, regulator and charger.
> > 
> > Both MAX14577 and MAX77836 chipsets are documented.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Cc: devicetree@vger.kernel.org
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > Cc: Kumar Gala <galak@codeaurora.org>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++++++++++++
> >  1 file changed, 152 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> > new file mode 100644
> > index 000000000000..b235250a7b41
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> > @@ -0,0 +1,152 @@
> > +Maxim MAX14577/77836 Multi-Function Device
> > +
> > +MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
> > +Battery Charger and SFOUT LDO output for powering USB devices. It is
> > +interfaced to host controller using I2C.
> > +
> > +MAX77836 additionally contains PMIC (with two LDO regulators) and Fuel Gauge.
> > +
> > +
> > +Required properties:
> > +- compatible : Must be "maxim,max14577" or "maxim,max77836".
> > +- reg : I2C slave address for the max14577 chip (0x25 for max14577/max77836)
> > +- interrupts : IRQ line for the chip.
> > +- interrupt-parent :  The parent interrupt controller.
> > +
> > +
> > +Required nodes:
> > + - charger :
> > +	Node for configuring the charger driver.
> > +	Required properties:
> > +		- compatible : "maxim,max14577-charger"
> > +			or "maxim,max77836-charger"
> > +		- maxim,fast-charge-timer : Timer in hours to trigger the
> > +			INT3/MBCCHGERR interrupt; Valid values:
> > +			- 5, 6 or 7 (hours),
> > +			- 0 to disable.
> 
> I'm not sure I follow what this is any why it should be in the DT.
> 
> Could you explain what this is used for?

Hi,

These are settings for max14577 battery charger. Actually this
particular setting does not look like board-specific but other (like
battery voltage) do.

The timer above is used by device to stop charging and to trigger
interrupt.

Best regards,
Krzysztof

> 
> Thanks,
> Mark.

