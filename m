Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAVBBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:01:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37458 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAVBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:01:35 -0500
X-AuditID: cbfee68d-f79296d000004278-9d-54c04becf020
Date: Thu, 22 Jan 2015 10:01:30 +0900
From: Inha Song <ideal.song@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kgene@kernel.org, linux-samsung-soc@vger.kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: exynos5422-odroidxu3: add sound nodes
Message-id: <20150122100130.75c20e9b@songinha-Samsung-DeskTop-System>
In-reply-to: <54BF9083.5090708@samsung.com>
References: <1421819923-27575-1-git-send-email-ideal.song@samsung.com>
 <54BF9083.5090708@samsung.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkSPeN94EQg/+zZS3mHznHatH/ZiGr
	xblXKxkt+h+/ZrbY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ti0br3CLvF4TftrA48
	HmvmrWH0aGnuYfO43NfL5LFy+Rc2j02rOtk8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M7p+zmQqWCFbcebCYpYHxBG8XIyeHhICJxLqDuxghbDGJC/fWs3UxcnEICSxllPj0pp0R
	pmj/zSvMEIlFjBIHNj5jgXD6mSRaXh1jBqliEVCVONOymh3EZhPQkPj+eTNYXERAX2LJqotg
	Y5kFVjBJzNk9B2yssICLRM+zq2wgNq+Aq8TisyfA4pwC2hLzDr0FiwsJpEv8PXWUGeIMG4nV
	O9cxQ9QLSvyYfI8FxGYW0JLYvK2JFcKWl9i85i3YqRICrRwSmz9MZoO4TkDi2+RDQA0cQAlZ
	iU0HoGZKShxccYNlAqPYLCRjZyEZOwvJ2AWMzKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	AuP49L9nvTsYbx+wPsQowMGoxMP7QnF/iBBrYllxZe4hRlOgKyYyS4km5wOTRV5JvKGxmZGF
	qYmpsZG5pZmSOK+i1M9goIcTS1KzU1MLUovii0pzUosPMTJxcEo1MJ5xnq6w2sFDlvPAR/Ya
	fset6Sontwk9iq1Z73Ls92NFj76Ce2sWcpwX/X8r25B9HQvHjgieCfeCZucazTc2OK6W8kDk
	zML0OUF37vky8nVJudtsqhRZzPjtXHSlR9pimVvhJxTENewPnPG53/G/qcU4ODj/78ENEpY3
	WWrtz8jblsosz1xZpsRSnJFoqMVcVJwIAPsvaAjeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd033gdCDLofi1jMP3KO1aL/zUJW
	i3OvVjJa9D9+zWyx6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbFonXvEXaLw2/aWR14
	PNbMW8Po0dLcw+Zxua+XyWPl8i9sHptWdbJ5bF5S79G3ZRWjx+dNcgEcUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA1yoplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM7p/zmYqWCJYcefBYpYGxhO8XYycHBICJhL7b15h
	hrDFJC7cW8/WxcjFISSwiFHiwMZnLBBOP5NEy6tjYFUsAqoSZ1pWs4PYbAIaEt8/bwaLiwjo
	SyxZdRGsm1lgBZPEnN1zGEESwgIuEj3PrrKB2LwCrhKLz54Ai3MKaEvMO/QWLC4kkC7x99RR
	qDNsJFbvXMcMUS8o8WPyPRYQm1lAS2LztiZWCFteYvOat8wTGAVmISmbhaRsFpKyBYzMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCk8Qz6R2MqxosDjEKcDAq8fC+UNwfIsSaWFZcmXuI
	UYKDWUmE10PjQIgQb0piZVVqUX58UWlOavEhRlNgcExklhJNzgcmsLySeENjEzMjSyNzQwsj
	Y3MlcV4l+7YQoN8SS1KzU1MLUotg+pg4OKUaGJfpLOfWOX2FZ83LgO3O15KOVD8TOKd0It0n
	6VCEIsemLY93M3p/DWq9f3O+/Gmpqv1FrQ3lbXIRlydNOL7l87T/6d5nnt1d8Oc3q6bVVtFN
	bDXPFByvx8TZ1Kwv/Gz2YO/VD8+nzTEQ/3cumWFDhPyzQJb60Mt5b+88k9rg/a35pIu2Q65y
	4gElluKMREMt5qLiRACIXsslKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comment.

On Wed, 21 Jan 2015 12:41:55 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

> Hi,
> 
> On 21/01/15 06:58, Inha Song wrote:
> > Add MAX98090 audio codec, I2S interface and the sound nodes to support
> > audio on Odroid-XU3 board.
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 34 ++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> > index 7874da2..79493d1 100644
> > --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> > +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> > @@ -310,6 +310,40 @@
> >  	rtc@101E0000 {
> >  		status = "okay";
> >  	};
> > +
> > +	sound: sound {
> > +		compatible = "samsung,odroidu3-audio";
> 
> How about using simple-card instead ? I've been trying to switch
> Odroid X2/U3 to simple card. Here a corresponding dts patch:
> http://www.spinics.net/lists/linux-samsung-soc/msg41083.html
> For that recent patches for the I2S driver which area already in -next
> might be needed.

Oh, I missed your patchs.
I will rework this patch based on your patch.

Best Regards,
Inha Song.

> 
> > +		samsung,model = "Odroid-XU3";
> > +		samsung,i2s-controller = <&i2s0>;
> > +		samsung,audio-codec = <&max98090>;
> > +		assigned-clocks = <&clock_audss EXYNOS_MOUT_AUDSS>,
> > +				  <&clock_audss EXYNOS_MOUT_I2S>;
> > +		assigned-clock-parents = <&clock CLK_FIN_PLL>,
> > +				<&clock_audss EXYNOS_MOUT_AUDSS>;
> > +		samsung,audio-routing =
> > +			"Headphone Jack", "HPL",
> > +			"Headphone Jack", "HPR",
> > +			"Headphone Jack", "MICBIAS",
> > +			"IN1", "Headphone Jack",
> > +			"Speakers", "SPKL",
> > +			"Speakers", "SPKR";
> > +	};
> > +};
> > +
> > +&hsi2c_5 {
> > +	status = "okay";
> > +	max98090: max98090@10 {
> > +		compatible = "maxim,max98090";
> > +		reg = <0x10>;
> > +		interrupt-parent = <&gpx3>;
> > +		interrupts = <2 0>;
> > +		clocks = <&clock_audss EXYNOS_DOUT_AUD_BUS>;
> > +		clock-names = "mclk";
> > +	};
> > +};
> 
> -- 
> Thanks,
> Sylwester
