Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaEFCfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:35:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:35:44 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-5c-53684a7b8e52
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Tomasz Stanislawski'" <t.stanislaws@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
References: <534E7A3F.7050406@samsung.com> <534E7F1A.8080502@samsung.com>
In-reply-to: <534E7F1A.8080502@samsung.com>
Subject: RE: [PATCH] arm: dts: exynos4: add missing pinctrls for I2C controllers
Date: Tue, 06 May 2014 11:35:38 +0900
Message-id: <099a01cf68d3$de1044b0$9a30ce10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI90i8zx/tL6O8TlCQCnrPTNlb+DQGYbHEhmkk/4qA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zfd1qr4xgg/ZefYuNM9azWkxad4DJ
	Yv6Rc6wW/W8Wslqce7WS0eJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NaLL1+kcliwvS1LBat
	e4+wW6yf8ZrFYl77S1YHfo8189YwerQ097B5XO7rZfL4u+oFs8fK5V/YPDat6mTz2Lyk3qNv
	yypGj8+b5AI4o7hsUlJzMstSi/TtErgyXs3ew1gwSaDixJ4v7A2MF7i7GDk5JARMJK5saGSE
	sMUkLtxbz9bFyMUhJLCMUeLC1stADgdY0dQfMRDxRYwSVw79BGsQEvjLKLHlsS2IzSagIXH4
	/TN2kHoRgSiJozPSQOqZBV4wSyy8epIFot5T4tPnE6wgNqeAtsSma5vZQWxhgQCJtd/mgcVZ
	BFQlpn+dCBbnFbCU2PlzMROELSjxY/I9sDnMAuoSk+YtYoaw5SU2r3nLDPGAgsSOs6/BbhMR
	sJJYPWcvO0SNiMS+F++gnjzBIbGvMRZil4DEt8mHWCB+lJXYdABqjKTEwRU3WCYwSsxCsnkW
	ks2zkGyehWTDAkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxgh6WLCDsZ7B6wPMSYDrZ/I
	LCWanA9MN3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwGi6duID4/CgvMtbKx1rlvEd+xQge8i1RH9Go0TvlJbnx5K2aWY09VUrRHW7eTrbnp7/
	8/C5GftPyNecLClrE1jdG75Fszvb7egChn8Tu08zN+llL3Q/frl0TdWmVZFFvHLXrNUufT2g
	ee1c3df2NabX7yQl9Jle+WR8dW/pW+GiasWwzuoCZyWW4oxEQy3mouJEABcNU+ItAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAd1qr4xgg+ZNWhYbZ6xntZi07gCT
	xfwj51gt+t8sZLU492olo8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1WHr9IpPFhOlrWSxa
	9x5ht1g/4zWLxbz2l6wO/B5r5q1h9Ghp7mHzuNzXy+Txd9ULZo+Vy7+weWxa1cnmsXlJvUff
	llWMHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4
	BOi6ZeYAfaCkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHg1ew9jwSSB
	ihN7vrA3MF7g7mLk4JAQMJGY+iOmi5ETyBSTuHBvPVsXIxeHkMAiRokrh34ygiSEBP4ySmx5
	bAtiswloSBx+/4wdpFdEIEri6Iw0kHpmgRfMEguvnmSBqPeU+PT5BCuIzSmgLbHp2mZ2EFtY
	IEBi7bd5YHEWAVWJ6V8ngsV5BSwldv5czARhC0r8mHwPbA6zgLrEpHmLmCFseYnNa94yQxyq
	ILHj7Guw20QErCRWz9nLDlEjIrHvxTvGCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzgdPZPawbiyweIQowAHoxIP74mV6cFCrIllxZW5hxglOJiVRHj9
	nTKChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmCrzSuINjU3MjCyNzCyMTMzNSRNWEuc9
	0GodKCSQnliSmp2aWpBaBLOFiYNTqoFx24wZIaVrt893ntgYcV0l49qanMA7FmXzs6vdXhxX
	sfn6dc67aZlqGwxmJF681+nB9Na0x0uWdY2E83nW7OBg3j87m3TqbkxZvOjAqTv/pPyDeGbd
	ExXa/31Tymm2Z7Y/DNfke19SWaov7FuQlaHcvPXLp8fNNXtVV/3rey9X+phJmWOP6sPTSizF
	GYmGWsxFxYkA7vC3vYsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Tomasz,
> 
> On 16.04.2014 14:40, Tomasz Stanislawski wrote:
> > This patch adds missing pinctrls for I2C controllers 2-7.
> >
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > ---
> >   arch/arm/boot/dts/exynos4.dtsi |   12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/exynos4.dtsi
> b/arch/arm/boot/dts/exynos4.dtsi
> > index 0401f4d..288aa81 100644
> > --- a/arch/arm/boot/dts/exynos4.dtsi
> > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > @@ -357,6 +357,8 @@
> >   		interrupts = <0 60 0>;
> >   		clocks = <&clock CLK_I2C2>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c2_bus>;
> >   		status = "disabled";
> >   	};
> >
> > @@ -368,6 +370,8 @@
> >   		interrupts = <0 61 0>;
> >   		clocks = <&clock CLK_I2C3>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c3_bus>;
> >   		status = "disabled";
> >   	};
> >
> > @@ -379,6 +383,8 @@
> >   		interrupts = <0 62 0>;
> >   		clocks = <&clock CLK_I2C4>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c4_bus>;
> >   		status = "disabled";
> >   	};
> >
> > @@ -390,6 +396,8 @@
> >   		interrupts = <0 63 0>;
> >   		clocks = <&clock CLK_I2C5>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c5_bus>;
> >   		status = "disabled";
> >   	};
> >
> > @@ -401,6 +409,8 @@
> >   		interrupts = <0 64 0>;
> >   		clocks = <&clock CLK_I2C6>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c6_bus>;
> >   		status = "disabled";
> >   	};
> >
> > @@ -412,6 +422,8 @@
> >   		interrupts = <0 65 0>;
> >   		clocks = <&clock CLK_I2C7>;
> >   		clock-names = "i2c";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&i2c7_bus>;
> >   		status = "disabled";
> >   	};
> >
> >
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
Applied, thanks.

- Kukjin

