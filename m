Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBEP5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:57:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15056 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaBEP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:57:10 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-cb-52f25f53c28c
From: Kamil Debski <k.debski@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Matt Porter'" <matt.porter@linaro.org>,
        tjakobi@math.uni-bielefeld.de,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
 <1391016574-25237-4-git-send-email-k.debski@samsung.com>
 <CAOesGMh8qEumWGb_mVuiSTWE=tsEusntG5r9xL3Z+f_WUnBQSw@mail.gmail.com>
In-reply-to: <CAOesGMh8qEumWGb_mVuiSTWE=tsEusntG5r9xL3Z+f_WUnBQSw@mail.gmail.com>
Subject: RE: [PATCH v6 3/8] dts: Add usb2phy to Exynos 4
Date: Wed, 05 Feb 2014 16:57:07 +0100
Message-id: <054401cf228a$ec10a9e0$c431fda0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8dM8+RpPiMwR5mSVGaFB1A4bgk5wFVJ37g
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xq7rB8Z+CDJ4sMbVYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBYXnvawWZxtegPk7prDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFqeuf2azOL+lk8ni8Jt2VosJvy+wWayf8ZrFom31B1aLjrMH2R1EPC739TJ57Jx1l93j
	zrU9bB5XTjSxevw7xu4x++4PRo++LasYPY7f2M7k8XmTXABnFJdNSmpOZllqkb5dAlfGqmef
	mAt+81Z0npjO3sC4iauLkYNDQsBE4sDD6i5GTiBTTOLCvfVsILaQwFJGiQUvdbsYuYDsBiaJ
	lhXvmUHq2QQ0JVbd8wCpERFQlXjypIsVpIZZYDmrxNQVh1ghGo4xSjzZ18kCUsUpECxx5NR/
	VhBbWMBCYu/p9+wgg1iAutsuG4OEeQUcJFobrzND2IISPybfA2tlFtCSWL/zOBOELS+xec1b
	Zoib1SUe/dWFuMFI4vK2GewQJSISdxues05gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqaXJBcVJ
	6bmGesWJucWleel6yfm5mxghEf1lB+PiY1aHGAU4GJV4eDtEPwYJsSaWFVfmHmKU4GBWEuFt
	jf0UJMSbklhZlVqUH19UmpNafIiRiYNTqoExbWdV5LyoTvP6M5tEZ/xoPtkUUX5Z3duf+euJ
	m7c+LH4Wn2f47+OvOrFfvTELY2bpGssdf/hm1Zf5veyHH7FqydrOzdB+PO1HktnpKfuaV7jF
	qoWsD/qzYw+b8akTKTMnXlv8177N/vfBjIKNv0Nn6G9xZJuYmXJ05nXFtV+y+XWY/jzYr7pR
	TYmlOCPRUIu5qDgRAIMEyT7GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

> From: Olof Johansson [mailto:olof@lixom.net]
> Sent: Wednesday, January 29, 2014 9:51 PM
> 
> On Wed, Jan 29, 2014 at 9:29 AM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > Add support to PHY of USB2 of the Exynos 4 SoC.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  .../devicetree/bindings/arm/samsung/pmu.txt        |    2 ++
> >  arch/arm/boot/dts/exynos4.dtsi                     |   31
> ++++++++++++++++++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   17
> +++++++++++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   17
> +++++++++++
> >  4 files changed, 67 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> > b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> > index 307e727..a76f91d 100644
> > --- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> > +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> > @@ -3,6 +3,8 @@ SAMSUNG Exynos SoC series PMU Registers
> >  Properties:
> >   - name : should be 'syscon';
> >   - compatible : should contain two values. First value must be one
> from following list:
> > +                  - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
> > +                  - "samsung,exynos4x12-pmu" - for Exynos4212 SoC,
> >                    - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
> >                    - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
> >                 second value must be always "syscon".
> 
> This and other PMU related bindings/dts changes should probably go in
> separate patch(es) instead of being snuck in with USB changes.

O, I will move this to a separate patch.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

