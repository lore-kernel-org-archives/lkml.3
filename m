Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3CMHaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:30:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28599 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3CMHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:30:23 -0400
X-AuditID: cbfee690-b7f656d0000007e3-1b-51402b027cce
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Naveen Krishna Ch'" <naveenkrishna.ch@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Wolfram Sang'" <wsa@the-dreams.de>, "'Simon Glass'" <sjg@chromium.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Yuvaraj Kumar'" <yuvaraj.cd@gmail.com>,
        "'Ben Dooks'" <ben.dooks@codethink.co.uk>,
        u.kleine-koenig@pengutronix.de,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Girish Shivananjappa'" <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        "'Prashanth G'" <prashanth.g@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Daniel Kurtz'" <djkurtz@chromium.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
 <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1360957573-864-2-git-send-email-dianders@chromium.org>
 <CAHfPSqAtxjYV79VvQZDLtzfyRxkYoMEc4=S2fN=KRNtYOEQ7ig@mail.gmail.com>
In-reply-to: <CAHfPSqAtxjYV79VvQZDLtzfyRxkYoMEc4=S2fN=KRNtYOEQ7ig@mail.gmail.com>
Subject: RE: [PATCH v3 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
Date: Wed, 13 Mar 2013 16:30:09 +0900
Message-id: <096801ce1fbc$979d1550$c6d73ff0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Z/AI3q5L+p39OSlaR0E29k67c4AFsTFIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zfV0mbYdAgyP32C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGy6ZTTAXL5SterLzJ0sB4ULSLkZNDQsBEonvVbDYIW0ziwr31
	QDYXh5DAMkaJuw0b2LsYOcCKJm62hYgvYpSYceMPC4Qzj0lixpYGJpBuNgENicPvn7GD2CIC
	8RIvJ61nAiliFtjGJvF73j92iI4GJomFX5rAqjgFgiWezH/PBLJCWCBA4sDJapAwi4CqxJSH
	/WBDeQVsJXbO3MkKYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIS9UlHv3VhbjBSKL9wDRG
	iBIRiX0v3jGCnCAhsIxd4uH670wQuwQkvk0+xALRKyux6QAzJCQkJQ6uuMEygVFiFpLNs5Bs
	noVk8ywkKxYwsqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECImtCTsY7x2wPsSYDLR+IrOU
	aHI+MDbzSuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cDIzRkfNFfgiMj6WCa2zbPj+qw6JnHUNQYt+i+/zPjGg6T9i55wrSqo5WfZvuF88XcfdYP7
	8VKeW6Q3/9M+Z23us+e8/8+vl+ZHPN3Ot3nhxa+HjoWr3PhwWF7uG/vk+/4XbeW5zD7ZyDfs
	vSj+PGze79dsM6Q8Co/tjX9pvTk7WEPqjFWVgvkFJZbijERDLeai4kQAXpprmcMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgC6jtkOgwd55NhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x42XTKaaC5fIVL1beZGlg
	PCjaxcjBISFgIjFxs20XIyeQKSZx4d56ti5GLg4hgUWMEjNu/GGBcOYxSczY0sAEUsUmoCFx
	+P0zdhBbRCBe4uWk9UwgRcwC29gkfs/7xw7R0cAksfBLE1gVp0CwxJP575lA1gkLBEgcOFkN
	EmYRUJWY8rAfbCivgK3Ezpk7WSFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHG1usSjv7oQ
	NxhJtB+YxghRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4cp9J7WBc2WBxiFGAg1GJh1fgq32gEGtiWXFl7iFGCQ5mJRHetktAId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpW8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamCUk7yxiMNlQ8UZfZdVEydcrGHTOL1VzCD/ec5Efu18XfbF+z5MdHE7
	tY+nJS1xE2NTmZBYwF2Gul4eT9ULs6RVGE5d9lZYtNx57l7FSZt5u9/PlC+e+s+s8Ovcud7Z
	r1bzr/6QYTszv2dh8LdzzLZvt9UufWmV8e9q4b36p7MOc+8wqp1nU/FNiaU4I9FQi7moOBEA
	FnexRCADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen Krishna Ch wrote:
> On 16 February 2013 04:46, Doug Anderson <dianders@chromium.org> wrote:
> > We need to use the i2c-arbitrator to talk to any of the devices on i2c
> > bus 4 on exynos5250-snow so that we don't confuse the embedded
> > controller (EC).  Add the i2c-arbitrator to the device tree.  As we
> > add future devices (keyboard, sbs, tps65090) we'll add them on top of
> > this.
> >
> > The arbitrated bus is numbered 104 simply as a convenience to make it
> > easier for people poking around to guess that it might have something
> > to do with the physical bus 4.
> >
> > The addition is split between the cros5250-common and the snow device
> > tree file since not all cros5250-class devices use arbitration.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> The patch set [v3] is tested on snow with test case which uses i2c-4 from both
> EC and AP side continuously for a more than a couple of minutes.
> 
Thanks for your test and looks good to me.

BTW, Doug, I think, this should be re-worked to use pinctrl. Can you?

Thanks.

- Kukjin

> > ---
> > Changes in v3: None
> > Changes in v2:
> > - Use new device tree property names / compatible string.
> > - Include that the GPIOs for arbitration are active low.
> >
> >  arch/arm/boot/dts/cros5250-common.dtsi |  5 ++++-
> >  arch/arm/boot/dts/exynos5250-snow.dts  | 25 +++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/cros5250-common.dtsi
> b/arch/arm/boot/dts/cros5250-common.dtsi
> > index 46c0980..f451375 100644
> > --- a/arch/arm/boot/dts/cros5250-common.dtsi
> > +++ b/arch/arm/boot/dts/cros5250-common.dtsi
> > @@ -58,7 +58,10 @@
> >         };
> >
> >         i2c@12CA0000 {
> > -               status = "disabled";
> > +               samsung,i2c-sda-delay = <100>;
> > +               samsung,i2c-max-bus-freq = <66000>;
> > +               gpios = <&gpa2 0 3 3 0>,
> > +                       <&gpa2 1 3 3 0>;
> >         };
> >
> >         i2c@12CB0000 {
> > diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
> b/arch/arm/boot/dts/exynos5250-snow.dts
> > index 17dd951..d2d4b48 100644
> > --- a/arch/arm/boot/dts/exynos5250-snow.dts
> > +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> > @@ -16,6 +16,10 @@
> >         model = "Google Snow";
> >         compatible = "google,snow", "samsung,exynos5250";
> >
> > +       aliases {
> > +               i2c104 = &i2c_104;
> > +       };
> > +
> >         gpio-keys {
> >                 compatible = "gpio-keys";
> >
> > @@ -29,6 +33,27 @@
> >                 };
> >         };
> >
> > +       i2c-arbitrator {
> > +               compatible = "i2c-arbitrator-cros-ec";
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +
> > +               i2c-parent = <&{/i2c@12CA0000}>;
> > +
> > +               ap-claim-gpio = <&gpf0 3 1 0x10000 0>;
> > +               ec-claim-gpio = <&gpe0 4 0 0x10003 0>;
> > +               slew-delay-us = <10>;
> > +               wait-retry-us = <3000>;
> > +               wait-free-us = <50000>;
> > +
> > +               /* Use ID 104 as a hint that we're on physical bus 4 */
> > +               i2c_104: i2c@0 {
> > +                       reg = <0>;
> > +                       #address-cells = <1>;
> > +                       #size-cells = <0>;
> > +               };
> > +       };
> > +
> >         /*
> >          * On Snow we've got SIP WiFi and so can keep drive strengths low to
> >          * reduce EMI.
> > --
> > 1.8.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> Shine bright,
> (: Nav :)

