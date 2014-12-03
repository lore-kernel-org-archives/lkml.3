Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaLCDim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:38:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61641 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLCDij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:38:39 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-6d-547e85bdacdc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Gyungoh Yoo'" <gyungoh@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, cooloney@gmail.com, broonie@kernel.org,
        lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        treding@nvidia.com, florian.vaussard@epfl.ch, trivial@kernel.org,
        linux@roeck-us.net, andrew@lunn.ch, jic23@kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
 <1417507529-13654-4-git-send-email-jack.yoo@skyworksinc.com>
 <20141202140727.GD22522@x1> <20141203030905.GA4352@jack-ThinkPad-T520>
In-reply-to: <20141203030905.GA4352@jack-ThinkPad-T520>
Subject: Re: [PATCH v9 3/8] devicetree: mfd: Add new SKY81452 mfd binding
Date: Wed, 03 Dec 2014 12:39:55 +0900
Message-id: <001701d00eaa$cdd0d970$69728c50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOpoak0lTx+uPnTXieFV4TgBl7ZwAA88Dw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0zMYRzH93x/3dU6vp3K0w1ZqI2R6tITwlm2x39M/sDIyXfV+umuGmYt
	0ZDKVYhbu1wr6ip0jI5wTjl2rU5XJ8OV3GShjM75zV1ftv57P/u835/X+9k+QlJspSXCtKxc
	TpElzwhlfKmWAOmxpXeKCxKX6y3+qPeliURnXjkZ1GWoIFBtZw+NusfKATr1Xksj4892gAyD
	W9GfkXc06hlrAmjg6BCFDtfbKGTT9tFouEhHoCFXF0Bf+o8TyHarhkFObTeBGp4+IZCqupVC
	xXc6BchykkbPf8xAE/dsxDqIWzQtANvKywh8sbiZxAb1SwFuujTJYL3uBIMLjb0UfmHvYLDm
	8WZsaP9M4LIj4ww2uAsFuPy6DuAmrZvBN+0aEn/Wz9vEbvddvZfLSMvnFBFrdvumTozeBTn2
	2fvHnGZBISgRlwAfIWSlsMfVLeB1ELQ6rjAlwFcoZhsAVLkMxH+T+9Mpih9UA2h+bSH5x3cA
	B02uKRfDhsHJyQdTqwLYjbD0VSPp1SRbTEHVjQQ+YAWwtuMP8A582Fh4+1nHlJ7lCbQ8PEd7
	NcUugm61i/JqERsPG7U6htf+8GuVg+KXhsNKTd0/wBLoHLd6skJP1XA48msp3yEK1lV+EvCW
	AHj37TjwdoBssw+8dv49w7NY+KXKRPHZuVBvJPkfB8P7jYOUCkD1NLJ6Glk9jayehrgAKB0I
	5HKSc5R7UhTSZUp5pjIvK2VZcnamHngOzfL7jaodOIyrTIAVglA/EdpVkCim5fnKA5kmEONp
	VEFKApOzPbeZlZsUGb0iCsVIY6KjYuNWhM4WvZN82yJmU+S5XDrH5XCKJEVeBqc0AULoIykE
	jNNVFKfvTzQWmNHCvuHwwDcLHjnmh/0Kk6brD5XKzorann9MNdsFwokXv+Pi/d15sp0bZFeK
	LrflBtVcIFamY02ifnQMaupdCdF2NECv/XrQkb3vakPCTNNpy+UyUfsOWZdhTut4yDy/2G1u
	ieXJqg/BlTJt4IKQ7LqI9daIUEqZKo9cTCqU8r+ftzSjYwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSaUwTQRTHnd3tdkFrloI6QWPIJmqCKUIFOh4YjcaMZ1BrNH6wLrABpC24
	CyhGsR4kgsrhEbWaYokiVNSIRqlypYoXBMEiQhQvGiVoMEEQoyC2VA3R+fSfN+/3f+9NHkMq
	zXQgk2hMFUQjr+doX6r+Z6efqiorUxta9cYXPelwkOjEWxeN6uwFBCq81yhDDd25AOV9sspQ
	7WAFQPa29Wj43UcZauwuBejZgdcU2nveSSGn9akMvdlnI9Dr/jqAvrYcJJDz9lkauawNBLrw
	vJlA+ScvUyir6p4c1R+SoRc/xqPPNU5iIcRlljKAnblHCFycdYnEdnOHHJde7KNxuS2bxqba
	JxR+2VpJY8ujNdhe8YXAR/b30Ng+YJLj3Bs2gEutAzS+1Woh8ZfyqdHsJhOYnyDwcYIYJBhj
	k+MSjfFR3Ip1usW6iMjQMFXYHKThgoy8QYjilqyMVi1N1Lv/gwtK5/Vp7lA0L0ncrAX/O6zX
	LlWhP+BG1Srt2r+MOvSfs+UKSPj8oRqktE7a0e16IDeBHGUO8GEgGw4HevMor54Im15dpXOA
	L6NkTwL4oLOe9F6+A9jm6Cc8WTQ7Hfb13ZV7dAC7DB5+W0J6NMlmUTD/5hIv0ARgYeUw8Dz4
	sBp4p71yRPu7gbL7p2QeTbHT4IC5f6S0go2CJVYb7dV+8NuxV5TXdAY8ain6XWAmdPU0uVnG
	3eoM+G5I5e1BDYuO9sq9KQGwuqsH5AOleZSTeZSTeZSTeRRyDlA2MEFIiU2RYuIN6hCJN0hp
	xviQ2GRDORjZy/eTK4DNhByAZQA3ToE2Z2qVMj5dyjA4AGRILkCRFOMOKeL4jJ2CmKwT0/SC
	5AAR7kELyMAJscnuLTem6sJmh0eq56gjkTpco+EmKdraDVolG8+nCkmCkCKIfziC8Qk0ARCi
	8x/TpXkYkbeoWNS3n2s0lLhwy4s4cfLQnuCMl+rCDmbK/OyoritA+ey83+px06Yuh9ddtZ1W
	hfRYTJ9XvXV2dpEu89gyLqSl33B8w3JLs6bmce+m44M12/p6CvSYnJt5elXzjqFrtUR0hGL3
	tu0Px14cnuKs216/y6Q+M/iIo6QEPiyYFCX+F63ATVGtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2014 12:09 PM, Gyungoh Yoo wrote:
> On Tue, Dec 02, 2014 at 02:07:27PM +0000, Lee Jones wrote:
> > This requires a DT Ack.
> 
> I think I need to double-check the recipients.
> Thank you for the comment.

Yes, right.
We should be careful when creating new DT properties.
This is because DT can be handled as ABI. Thus, Ack from
DT maintainers is necessary for merging new DT properties,
even though other subsystem maintainers or reviews gave
Ack for this.

Best regards,
Jingoo Han

> 
> >
> > > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > >
> > > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > > ---
> > > Changes v9:
> > > Nothing
> > >
> > > Changes v8:
> > > Made up the example for backlight DT
> > >
> > > Changes v7:
> > > Nothing
> > >
> > > Changes v6:
> > > Nothing
> > >
> > > Changes v5:
> > > Changed DT for regulator : 'lout' node should be defined under 'regulator'
> > > Removed compatible string from sky81452-regulator driver
> > >
> > > Changes v4:
> > > Nothing
> > >
> > > Changes v3:
> > > Nothing
> > >
> > > Changes v2:
> > > Added reg attribute for I2C slave address
> > >
> > >  Documentation/devicetree/bindings/mfd/sky81452.txt | 36 ++++++++++++++++++++++
> > >  1 file changed, 36 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt
> b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > > new file mode 100644
> > > index 0000000..ab71473
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > > @@ -0,0 +1,36 @@
> > > +SKY81452 bindings
> > > +
> > > +Required properties:
> > > +- compatible	: Must be "skyworks,sky81452"
> > > +- reg		: I2C slave address
> > > +
> > > +Required child nodes:
> > > +- backlight	: container node for backlight following the binding
> > > +		in video/backlight/sky81452-backlight.txt
> > > +- regulator	: container node for regulators following the binding
> > > +		in regulator/sky81452-regulator.txt
> > > +
> > > +Example:
> > > +
> > > +	sky81452@2c {
> > > +		compatible = "skyworks,sky81452";
> > > +		reg = <0x2c>;
> > > +
> > > +		backlight {
> > > +			compatible = "skyworks,sky81452-backlight";
> > > +			name = "pwm-backlight";
> > > +			skyworks,en-channels = <0x3f>;
> > > +			skyworks,ignore-pwm;
> > > +			skyworks,phase-shift;
> > > +			skyworks,ovp-level = <20>;
> > > +			skyworks,current-limit = <2300>;
> > > +		};
> > > +
> > > +		regulator {
> > > +			lout {
> > > +				regulator-name = "sky81452-lout";
> > > +				regulator-min-microvolt = <4500000>;
> > > +				regulator-max-microvolt = <8000000>;
> > > +			};
> > > +		};
> > > +	};
> >
> > --
> > Lee Jones
> > Linaro STMicroelectronics Landing Team Lead
> > Linaro.org │ Open source software for ARM SoCs
> > Follow Linaro: Facebook | Twitter | Blog

