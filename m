Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3GYXwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:52:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19502 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3GYXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:52:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-7b-51f1ba29382a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <1374757513-2253-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374757513-2253-4-git-send-email-maxime.ripard@free-electrons.com>
In-reply-to: <1374757513-2253-4-git-send-email-maxime.ripard@free-electrons.com>
Subject: Re: [PATCHv2 3/3] fb: backlight: HX8357: Add HX8369 support
Date: Fri, 26 Jul 2013 08:52:09 +0900
Message-id: <002301ce8991$f9b82060$ed286120$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHCDYD0czrDmGulXhA3S6xfgAYWkQG8m7/lmYEi/AA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zY13NXR8DDS4+V7TouLaYyeLJz/Ws
	FpcXXmK12PT4GqvFib4PQO6uOWwWWzftZbZY9/AFk8WLph3sFuvn32Jz4PKYdXU2o8eTTRcZ
	PV5duMPisXlJvUffllWMHsdvbGfy+LxJLoA9issmJTUnsyy1SN8ugSvjyLFTrAUL2SrW/vrN
	3sDYw9rFyMkhIWAi8a/hNTOELSZx4d56NhBbSGAZo8SlqfYwNafe72LpYuQCii9ilNg2t5UN
	wvnFKDHtxSYWkCo2ATWJL18Os4PYIgJpEkdvv2QGKWIWmMgkce9tIytEx1RGiZmXpoLt4xQI
	kGi8eR2sQ1jARWLKkT1gk1gEVCW+vG5lBLF5BSwlNp7/yg5hC0r8mHwPrIZZQEti/c7jTBC2
	vMTmNW+hflCQ2HH2NSPEFVYSPRv7oWpEJPa9eMcIcoSEQCeHxIydDxkhlglIfJt8CGgoB1BC
	VmLTAag5khIHV9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl
	5+duYoTEfN8OxpsHrA8xJgOtn8gsJZqcD0wZeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgnHxnykyl/R95Of3zDhxa5NKWx5Flzvvs42a2nUta
	Zqls1mLIVsq+5iWSHGe8J15bR+wck8riCi/XB6Ex1fW214Kmdt1WL56TkM71h7/78L1da4/e
	0s+IfVm3bvLHJS9PtC5cvNz3Z++EBaxzJTlyO28m+rX2/Y3YdeXcxXV3Ob3mfjj76WqihRJL
	cUaioRZzUXEiAOV7p1QPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAV3NXR8DDZaukbXouLaYyeLJz/Ws
	FpcXXmK12PT4GqvFib4PQO6uOWwWWzftZbZY9/AFk8WLph3sFuvn32Jz4PKYdXU2o8eTTRcZ
	PV5duMPisXlJvUffllWMHsdvbGfy+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jxpFjp1gLFrJVrP31m72BsYe1i5GTQ0LAROLU+10sELaYxIV769m6GLk4hAQW
	MUpsm9sK5fxilJj2YhNYFZuAmsSXL4fZQWwRgTSJo7dfMoMUMQtMZJK497aRFaJjKqPEzEtT
	mUGqOAUCJBpvXgfrEBZwkZhyZA/YJBYBVYkvr1sZQWxeAUuJjee/skPYghI/Jt8Dq2EW0JJY
	v/M4E4QtL7F5zVtmiFsVJHacfc0IcYWVRM/GfqgaEYl9L94xTmAUmoVk1Cwko2YhGTULScsC
	RpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEp5ZnUDsaVDRaHGAU4GJV4eBWcPgYKsSaW
	FVfmHmKU4GBWEuG91QsU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgussriTc0NjEzsjQy
	szAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZOi6ldUnu0VvUtOiQdq8MeFpR1
	kKVbxXaqaKpU36MzWU4s+/w2b8tdmG2uwCKu+P3TD6PZIbYKO88ym++4XbVe6+Xe+Y0X1m3W
	sH3h2Z4TyhJQ66Gl1DFbXn3JxAa+f6/L5k+59NF/s4kWW3Xo+Q4XZ3s5re8WqtGbpn9y/fMo
	aB3/TdNlPkosxRmJhlrMRcWJANz862JtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 10:05 PM, Maxime Ripard wrote:
> 
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Add support for the Himax HX8369 controller as it is quite similar to the
> hx8357.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/hx8357.c | 221 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 206 insertions(+), 15 deletions(-)
> 

[....]

> +	ret = hx8357_spi_write_byte(lcdev, HX8357_SET_DISPLAY_ON);
> +	if (ret < 0)
> +		return ret;
> +
> +	msleep(100);

Hi Maxime Ripard,

Could you add comment on this huge delay, too?

Best regards,
Jingoo Han


