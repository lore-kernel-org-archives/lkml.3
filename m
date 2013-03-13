Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3CMFKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:10:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34047 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3CMFKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:10:48 -0400
X-AuditID: cbfee690-b7f656d0000007e3-a8-51400a4e7992
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1363126175.3137.160.camel@x61.thuisdomein>
In-reply-to: <1363126175.3137.160.camel@x61.thuisdomein>
Subject: RE: [PATCH] ASoC: samsung: remove last traces of neo1973-gta01
Date: Wed, 13 Mar 2013 14:10:37 +0900
Message-id: <093301ce1fa9$19903ba0$4cb0b2e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4fbkoTZffPAgxeQyip47BEJ5DZlgAOCa/w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zka4fl0OgwcltLBZXLh5ispi07gCT
	xb/Zp9gsvl3pYLLY9Pgaq8XlXXPYLGac38dksejWGWaLzl39rBYXV3xhsni5+Q2TA7fHhs9N
	bB5/V71g9tg56y67x+Yl9R4vJ/5m89j3dhmbR9+WVYwem09Xe2zc/oTJ4/MmuQCuKC6blNSc
	zLLUIn27BK6MS9PWsBdM56o41PKZtYFxPUcXIyeHhICJxLmZ+xghbDGJC/fWs3UxcnEICSxj
	lFjX8ZYVpuj89ItsILaQwHRGiY33yiCK/jJKTG+7zASSYBPQkDj8/hk7SEJEYDKTxNF1m1hA
	HGaBDkaJ/VO3MEO0m0tsPrAObBSngIXEp6stYLuFBdwlNr/vBIuzCKhKtK/qAJvKK2ArsfEy
	RD2vgKDEj8n3gIZyAA1Vl5gyJRckzCwgL7F5zVtmkLAEUPjRX10QU0TASGLOchOIChGJfS/e
	MYJcIyGwkkOiZeI7dohNAhLfJh9igWiVldh0gBniX0mJgytusExglJiFZO8shL2zkOydhWTD
	AkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghCWHCDsZ7B6wPMSYDbZ/ILCWanA9MKHkl
	8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDRlOi7+
	eVfVnKMlZpdyz968YLvb/xZHR+IBt5jD+64UvNybtWlP6fPer09WcBd5xRZb+K4X8ubev9Qk
	SnLt4633Z3QWXFt83LIu54fQZMaId1FLNSb3f5v1Q2HXB7ajm4XLjqUt5BHJbrEJjeK+ddvy
	E8fKyRw7Vry/t9JT3/fPtpKwyVkiEl5KLMUZiYZazEXFiQDkUvTNHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQV1fLodAg7czbSyuXDzEZDFp3QEm
	i3+zT7FZfLvSwWSx6fE1VovLu+awWcw4v4/JYtGtM8wWnbv6WS0urvjCZPFy8xsmB26PDZ+b
	2Dz+rnrB7LFz1l12j81L6j1eTvzN5rHv7TI2j74tqxg9Np+u9ti4/QmTx+dNcgFcUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMy5NW8NeMJ2r4lDLZ9YGxvUcXYycHBIC
	JhLnp19kg7DFJC7cWw9mCwlMZ5TYeK+si5ELyP7LKDG97TITSIJNQEPi8Ptn7CAJEYHJTBJH
	121iAXGYBToYJfZP3cIM0W4usfnAOrBRnAIWEp+utjCC2MIC7hKb33eCxVkEVCXaV3WATeUV
	sJXYeBminldAUOLH5HtAQzmAhqpLTJmSCxJmFpCX2LzmLTNIWAIo/OivLogpImAkMWe5CUSF
	iMS+F+8YJzAKzUIyZxbCnFlI5sxC0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnC6
	eSa9g3FVg8UhRgEORiUeXok0+0Ah1sSy4srcQ4wSHMxKIrxtl4BCvCmJlVWpRfnxRaU5qcWH
	GJOBvpzILCWanA9MhXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwOj1+avHVAWduqplS4T0JFPsm68Vip4Jj2plvlTT5Vlc+X/BAdU55q+7FU7onldKznk3
	R6fBu/vlvPWFPxsj1zaVMed9m8em+PXxCbMVUrGCN5+nqp3m6LymfvZyrEni+fgj+xaZtBvq
	f5I8+Xltv/3m9AcXN7DxrxCZaLqRa6dKYv+KSXsVXJVYijMSDbWYi4oTARY6zu17AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The (rudimentary) support for the Openmoko Neo1973 GTA01 got removed in
> commit 1ae5cbc52e7c6619a3f44b87809fd25370df31bb ("ASoC: neo1973_wm8753:
> remove references to the neo1973-gta01 machine"). Remove its last traces
> in the Kconfig file too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

- Kukjin

> ---
> Untested.
> 
>  sound/soc/samsung/Kconfig | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
> index 90e7e66..475fb0d 100644
> --- a/sound/soc/samsung/Kconfig
> +++ b/sound/soc/samsung/Kconfig
> @@ -35,11 +35,10 @@ config SND_SAMSUNG_I2S
>  	tristate
> 
>  config SND_SOC_SAMSUNG_NEO1973_WM8753
> -	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA01/GTA02)"
> -	depends on SND_SOC_SAMSUNG && (MACH_NEO1973_GTA01 || MACH_NEO1973_GTA02)
> +	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA02)"
> +	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA02
>  	select SND_S3C24XX_I2S
>  	select SND_SOC_WM8753
> -	select SND_SOC_LM4857 if MACH_NEO1973_GTA01
>  	select SND_SOC_DFBMCS320
>  	help
>  	  Say Y here to enable audio support for the Openmoko Neo1973
> --
> 1.7.11.7

