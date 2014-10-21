Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaJUMZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:25:07 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32463 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJUMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:25:04 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-fb-5446509c0678
Message-id: <1413894298.31665.10.camel@AMDC1943>
Subject: Re: [PATCH v2 4/4] ARM: dts: exynos4412-trats: Add suspend
 configuration for max77686 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 21 Oct 2014 14:24:58 +0200
In-reply-to: <54464BC1.40201@collabora.co.uk>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
 <1413890597-31037-5-git-send-email-k.kozlowski@samsung.com>
 <54464BC1.40201@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7pzAtxCDD7clbDYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37BbfrnQwWWx6fI3V4vKuOWwWM87vY7K4
	fZnXYu2Ru+wOfB4tzT1sHn+fX2fx+LvqBbPHzll32T02repk89i8pN6jb8sqRo/Pm+QCOKK4
	bFJSczLLUov07RK4Mu5tvMxSsJ+zYsuapewNjCfZuxg5OSQETCT+Tj/HBGGLSVy4t56ti5GL
	Q0hgKaPEvduLmSCcz4wSJ08vBKviFTCQuHaqCcjm4BAWyJZYOyUYJMwmYCyxefkSNhBbRMBO
	4sbqh8wgvcwCP5klHrUdYwFJsAioSsz5eYMVpJdTQFeiZVIsSFhIYAWjxNUZFSA2s4C6xKR5
	i5hBSiQElCUa+90gtgpK/Jh8jwWiRF5i85q3zBMYBWYh6ZiFpGwWkrIFjMyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MUIi6OsOxqXHrA4xCnAwKvHwRixxDRFiTSwrrsw9xCjBwawkwpsr
	7BYixJuSWFmVWpQfX1Sak1p8iJGJg1OqgXGtplu4EvsC7xMlNw65tUnNFLrOtfNwSnZeneZn
	Bu2G3yd9XvtM8/5Zy3BybjCj9bwb8leW8tw4NTvltau/89fHu9Sf/u3w37cyeon619b50Re0
	HrVtfZdWE/8gtIlry+PTLz8FOIZfM1p76+hGK2XTt9ebIw4qzZObOLt29tELbmuLuj88P/BP
	iaU4I9FQi7moOBEAsXrrFH4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 14:04 +0200, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/21/2014 01:23 PM, Krzysztof Kozlowski wrote:
> > Add suspend to RAM configuration for max77686 regulators. Some LDOs and
> > bucks are disabled. This reduces energy consumption during S2R,
> > approximately from 17 mA to 9 mA.
> > 
> > Additionally remove old and not supported bindings:
> >  - regulator-mem-off
> >  - regulator-mem-idle
> >  - regulator-mem-on
> > The max77686 driver does not parse them and they are not documented
> > anywere.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++++--------------
> >  1 file changed, 42 insertions(+), 30 deletions(-)
> > 
> 
> I'm not familiar with the board but the change looks good to me assuming each
> regulator is doing the right thing.
> 
> I already gave you my Reviewed-by for the previous version but was not carried:
> 
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thanks! I didn't add your review-by-tag because changes in the patch.

Best regards,
Krzysztof


> 
> Best regards,
> Javier

