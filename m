Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3EXLLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:11:11 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41229 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3EXLLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:11:10 -0400
MIME-Version: 1.0
In-Reply-To: <1369391960-27320-2-git-send-email-fabio.baltieri@linaro.org>
References: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
	<1369391960-27320-2-git-send-email-fabio.baltieri@linaro.org>
Date: Fri, 24 May 2013 13:11:09 +0200
Message-ID: <CACRpkdbbi9u80RX+VHv+d3o3M+MfUZkR7thxFfqT62LeNq_AnA@mail.gmail.com>
Subject: Re: [PATCH 1/6] ASoC: ux500: Drop pinctrl sleep support
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 12:39 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Drop pinctrl default/sleep state switching code, as it was breaking the
> capture interface by putting the I2S pins in hi-z mode regardless of its
> usage status, and not giving any real benefit.
>
> Pinctrl default mode configuration is already managed automatically by a
> specific pinctrl hog.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
