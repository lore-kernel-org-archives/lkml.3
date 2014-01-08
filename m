Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaAHKRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:17:32 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54807 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaAHKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:17:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
References: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
Date: Wed, 8 Jan 2014 11:17:28 +0100
Message-ID: <CACRpkdYet_yzg0jhd4DiEyTMjL42FAb9DsYPWRv=AXVbz1Tvuw@mail.gmail.com>
Subject: Re: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 11:13 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fixes the following sparse warning:
>
> sound/soc/ux500/ux500_msp_i2s.c:649:5: warning:
>  symbol 'ux500_msp_i2s_of_init_msp' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Lee, is this something that needs to go along with your patches to
ASoC or can I apply this separately?

Yours,
Linus Walleij
