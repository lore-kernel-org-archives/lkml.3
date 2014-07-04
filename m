Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaGDINm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:13:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22800 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:13:35 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-14-53b6621cc280
Content-transfer-encoding: 8BIT
Message-id: <1404461597.21830.2.camel@AMDC1943>
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
Date: Fri, 04 Jul 2014 10:13:17 +0200
In-reply-to: <20140704080702.GA31812@leverpostej>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
 <1404198121-22989-6-git-send-email-k.kozlowski@samsung.com>
 <20140703113236.GA28504@leverpostej> <1404387874.21377.8.camel@AMDC1943>
 <20140704080702.GA31812@leverpostej>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4ZV2ZpG3BBt9381lsnLGe1WLqwyds
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdmmN+wW978eZbT4dqWDyeLyrjlsFmuP3GW3
	WHr9IpPFhOlrWSxa9x5htzjdzWqxfsZrFgdBjzXz1jB6XO7rZfLYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnr0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxpXXR5gKVkhV9M2+xNTA
	eFSki5GTQ0LARGJh2zV2CFtM4sK99WxdjFwcQgJLGSWO334GluAVEJT4MfkeSxcjBwezgLzE
	kUvZIGFmAXWJSfMWMUPUf2aUWNd6EqpeX6Lr8FcWEFtYIE5i9fqfYHE2AWOJzcuXsIHYIkDN
	Pbu+sIA0MwvsZpU42jyJFSTBIqAqceDGarAGTgFDiY8370Bt+M4oseL/WahTlSXm7T/GNIFR
	YBaSA2chHDgLyYELGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTE3ZcdjIuPWR1iFOBg
	VOLhbVyxIViINbGsuDL3EKMEB7OSCG+V0rZgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYz82hcr
	snbuyjnC/36revqxq2/uCaR42/hP+S5mnXv2fP3Cw688bi+5vLNF8773n+2LVFda73risLVa
	MdD9xoQM7bVzaqa+V7s7Pa1fy3paYO3nln9BAWZW3Zq3ebYcjPMN6RKakNAvdFLYZn1X18Nz
	Er/M/5t+uWbJfuEcP/vW1Oz168LVbT2UWIozEg21mIuKEwHo10cimQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 09:07 +0100, Mark Rutland wrote:
> On Thu, Jul 03, 2014 at 12:44:34PM +0100, Krzysztof Kozlowski wrote:
> > On czw, 2014-07-03 at 12:32 +0100, Mark Rutland wrote:
> > > Hi,
> > > 
> > > On Tue, Jul 01, 2014 at 08:02:00AM +0100, Krzysztof Kozlowski wrote:
> > > > Add document describing device tree bindings for MAX14577 MFD
> > > > drivers: MFD core, extcon, regulator and charger.
> > > > 
> > > > Both MAX14577 and MAX77836 chipsets are documented.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > > Cc: Tomasz Figa <t.figa@samsung.com>
> > > > Cc: devicetree@vger.kernel.org
> > > > Cc: Rob Herring <robh+dt@kernel.org>
> > > > Cc: Pawel Moll <pawel.moll@arm.com>
> > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > > > Cc: Kumar Gala <galak@codeaurora.org>
> > > > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++++++++++++
> > > >  1 file changed, 152 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> > > > new file mode 100644
> > > > index 000000000000..b235250a7b41
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> > > > @@ -0,0 +1,152 @@
> > > > +Maxim MAX14577/77836 Multi-Function Device
> > > > +
> > > > +MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
> > > > +Battery Charger and SFOUT LDO output for powering USB devices. It is
> > > > +interfaced to host controller using I2C.
> > > > +
> > > > +MAX77836 additionally contains PMIC (with two LDO regulators) and Fuel Gauge.
> > > > +
> > > > +
> > > > +Required properties:
> > > > +- compatible : Must be "maxim,max14577" or "maxim,max77836".
> > > > +- reg : I2C slave address for the max14577 chip (0x25 for max14577/max77836)
> > > > +- interrupts : IRQ line for the chip.
> > > > +- interrupt-parent :  The parent interrupt controller.
> > > > +
> > > > +
> > > > +Required nodes:
> > > > + - charger :
> > > > +	Node for configuring the charger driver.
> > > > +	Required properties:
> > > > +		- compatible : "maxim,max14577-charger"
> > > > +			or "maxim,max77836-charger"
> > > > +		- maxim,fast-charge-timer : Timer in hours to trigger the
> > > > +			INT3/MBCCHGERR interrupt; Valid values:
> > > > +			- 5, 6 or 7 (hours),
> > > > +			- 0 to disable.
> > > 
> > > I'm not sure I follow what this is any why it should be in the DT.
> > > 
> > > Could you explain what this is used for?
> > 
> > Hi,
> > 
> > These are settings for max14577 battery charger. Actually this
> > particular setting does not look like board-specific but other (like
> > battery voltage) do.
> > 
> > The timer above is used by device to stop charging and to trigger
> > interrupt.
> 
> Ok. What I don't get is why this should be in the DT, it sounds like a
> configuration option that would better be set at run time.

I understand. I'll add this as sysfs entry and re-spin with version 3 of
patchset.

Best regards,
Krzysztof

