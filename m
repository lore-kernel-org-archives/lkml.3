Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3JJEFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:05:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43494 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3JJEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:05:51 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-c1-5256279e283f
Message-id: <525627A2.70709@samsung.com>
Date: Thu, 10 Oct 2013 13:05:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/3] ARM: dts: exynos4x12: Add maudio/gps_alive power
 domain for exynos4x12
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
 <1381365007-1782-4-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHxr27nsmaqkE+seDgZAkpUmOsPqdXdeogY89tAXYEEG2w@mail.gmail.com>
In-reply-to: <CAK9yfHxr27nsmaqkE+seDgZAkpUmOsPqdXdeogY89tAXYEEG2w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkUHeeeliQwfy33Bbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12Lp9YtMFhOmr2WxOLziAJPFyT+9jBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vHnWt72Dw2L6n36NuyitHj8yY5j41z
	QwM4o7hsUlJzMstSi/TtErgymtZPYCpYzFVxdUYzYwNjE0cXIweHhICJxOSHnF2MnECmmMSF
	e+vZQGwhgaWMEqtP60HETSTeHPkNFOcCii9ilJjRfJAdwnnFKDH73T6wDl4BDYm3iy6wgtgs
	AqoSB++eZQax2QS0JPa/uAFWIyoQJrFy+hUWiHpBiR+T74HZIkA1L7uXM4EMZRboZZE4c/YE
	2CBhgUSJFX8OsUJsO8YosXFHJ1iCUyBYYsGbe2A2s4COxP7WaWwQtrzE5jVvmUEaJARmckhc
	OnSNHeIkAYlvkw+xQPwsK7HpADPEb5ISB1fcYJnAKDYLyVGzkIydhWTsAkbmVYyiqQXJBcVJ
	6UWmesWJucWleel6yfm5mxiBEX7637OJOxjvH7A+xJgMtHIis5Rocj4wQeSVxBsamxlZmJqY
	GhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVEjTuvEbGs3vlvZAqc0
	Olkj9HeLun+/oDkp5dyN81/OKjwQMFrx7/qDF9FHZptLl5cwzOB0CMsLNpRa9DNpv9LmazPM
	og+2zDvgqOM5gSv0QF/5veeT9kUudVjh2xofKcdxlzn879UMDy6dcCZdv8e5y6bsXr6oeclC
	mbc/bIQSziuJTrsosUmJpTgj0VCLuag4EQBIBIAJBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAd156mFBBp/nM1vMP3KO1eLcq5WM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbF4vCKA0wWJ//0Mlq8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wed67tYfPYvKTeo2/LKkaPz5vkPDbO
	DQ3gjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB
	ul1JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmNG0fgJTwWKuiqszmhkb
	GJs4uhg5OSQETCTeHPnNBmGLSVy4tx7I5uIQEljEKDGj+SA7hPOKUWL2u31gVbwCGhJvF11g
	BbFZBFQlDt49ywxiswloSex/cQOsRlQgTGLl9CssEPWCEj8m3wOzRYBqXnYvZwIZyizQyyJx
	5uwJsEHCAokSK/4cYoXYdoxRYuOOTrAEp0CwxII398BsZgEdif2t09ggbHmJzWveMk9gFJiF
	ZMksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcQp5J7WBc2WBxiFGAg1GJ
	h7eiLDRIiDWxrLgy9xCjBAezkgjv9JNAId6UxMqq1KL8+KLSnNTiQ4zJwDCYyCwlmpwPTG95
	JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cAYF9T5uTikabv8
	a5mbP6PZqrxN+mvusEU831lpoTtngnZl7hFmHwemlRa95vkvBfOd1MqD2+Yk1my1se6U5OYS
	dDwR8O1N3O7Af9dEcg9v2m4+/9EqLcakqpks7D/aT9QdDf1iznsujW/9Iilfxel/vtct+bL7
	uf6TqRqbvmyPfi9g2duSnqXEUpyRaKjFXFScCADQai0iZQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 12:29 PM, Sachin Kamat wrote:
> On 10 October 2013 06:00, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch maudio/gps_alive power domain to exynos4x12.dtsi.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>> index ad531fe..c04418e 100644
>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>> @@ -35,6 +35,16 @@
>>                 reg = <0x10023CA0 0x20>;
>>         };
>>
>> +       pd_maudio: maudio-power-domain@10023CC0 {
>> +               compatible = "samsung,exynos4210-pd";
>> +               reg = <0x10023CC0 0x20>;
>> +       };
>> +
>> +       pd_gps_alive: gps-alive-power-domain@10023D04 {
>> +               compatible = "samsung,exynos4210-pd";
>> +               reg = <0x10023D00 0x20>;
> 
> There is mismatch between node name and register value.
> 
> 
What is exactly mismatch?

I checked the register address of MAUDIO_CONFIGURATION/GPS_ALIVE_CONFIGURATION regsiter.
- MAUDIO_CONFIGURATION 0x1002_3CC0
- GPS_ALIVE_CONFIGURATION 0x1002_3D00


