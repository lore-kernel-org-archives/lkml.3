Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaAHKPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:15:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbaAHKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:15:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linus.walleij@linaro.org, fabio.baltieri@linaro.org,
        lee.jones@linaro.org, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
Date: Wed, 08 Jan 2014 11:14:44 +0100
Message-ID: <3148126.Rai0JT7dud@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
References: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZA8kJqARbaoT1alLNZWtk37NCdCoKOE6Hh5vJ5h2rOM
 EAapo0VjOSlRXxZksffWBjOL3AP0dD2XxuSm9/4P6Il/XNdTun
 61zpUNKk9G4zi9Nx2CBGBj5HI5wJkcFyqXYRWIJWH25+/ugGKp
 2DUDaOYBBt3dip4lXNuz1JWOAI+33fAbWu1SNDYGSQmgLCVpGi
 LbxIzWwXLIbtKam/2ZXNcYM9vVBGH444A0842ZTEgyN74CmhWL
 0mAqg4aoli+GTIlXIr7Z3sE1az8wPA+IGrbbT9JXRCMP7ivp6D
 FVz0EumwXbevD/Ed3lbZVpxd3MTac7cmk7LppEgB6ZuyQyHTvS
 P+kYUAH4uGhkbObvgLrM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 18:13:35 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> sound/soc/ux500/ux500_msp_i2s.c:649:5: warning:
>  symbol 'ux500_msp_i2s_of_init_msp' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
