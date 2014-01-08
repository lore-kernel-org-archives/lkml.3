Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaAHL6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:58:09 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33555 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbaAHL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:58:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140108110603.GG19974@lee--X1>
References: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
	<CACRpkdYet_yzg0jhd4DiEyTMjL42FAb9DsYPWRv=AXVbz1Tvuw@mail.gmail.com>
	<20140108110603.GG19974@lee--X1>
Date: Wed, 8 Jan 2014 12:58:06 +0100
Message-ID: <CACRpkdbq5zWX2o9tOhxMastRChEigvkSRVoz+7UEvF9AOaBUHQ@mail.gmail.com>
Subject: Re: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
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

On Wed, Jan 8, 2014 at 12:06 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 08 Jan 2014, Linus Walleij wrote:
>
>> On Wed, Jan 8, 2014 at 11:13 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> >
>> > Fixes the following sparse warning:
>> >
>> > sound/soc/ux500/ux500_msp_i2s.c:649:5: warning:
>> >  symbol 'ux500_msp_i2s_of_init_msp' was not declared. Should it be static?
>> >
>> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> FWIW: Acked-by: Lee Jones <lee.jones@linaro.org>
>
>> Lee, is this something that needs to go along with your patches to
>> ASoC or can I apply this separately?
>
> If Mark takes it, then it will just apply as my patches have already
> been applied.

Mark can you take this patch to minimize the fuzz?

Yours,
Linus Walleij
