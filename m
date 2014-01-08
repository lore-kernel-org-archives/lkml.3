Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaAHLGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:06:11 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35948 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaAHLGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:06:09 -0500
Date: Wed, 8 Jan 2014 11:06:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, "perex@perex.cz" <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
Message-ID: <20140108110603.GG19974@lee--X1>
References: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
 <CACRpkdYet_yzg0jhd4DiEyTMjL42FAb9DsYPWRv=AXVbz1Tvuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYet_yzg0jhd4DiEyTMjL42FAb9DsYPWRv=AXVbz1Tvuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jan 2014, Linus Walleij wrote:

> On Wed, Jan 8, 2014 at 11:13 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Fixes the following sparse warning:
> >
> > sound/soc/ux500/ux500_msp_i2s.c:649:5: warning:
> >  symbol 'ux500_msp_i2s_of_init_msp' was not declared. Should it be static?
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

FWIW: Acked-by: Lee Jones <lee.jones@linaro.org>

> Lee, is this something that needs to go along with your patches to
> ASoC or can I apply this separately?

If Mark takes it, then it will just apply as my patches have already
been applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
