Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3ETO7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:59:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37778 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3ETO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ1zBrp+jpgw8o_PVd_bcQMpkFXvRAwfJH6KCztT4jx+w@mail.gmail.com>
References: <1368746388-20194-1-git-send-email-dianders@chromium.org>
	<1368765198-25550-1-git-send-email-dianders@chromium.org>
	<CACRpkdZ1zBrp+jpgw8o_PVd_bcQMpkFXvRAwfJH6KCztT4jx+w@mail.gmail.com>
Date: Mon, 20 May 2013 07:59:27 -0700
X-Google-Sender-Auth: S3aRlHM70kbKaAW1eQxTc5bsGZs
Message-ID: <CAD=FV=XOiVdkEhYu+u-aGkD0DpxWn369uD_r4Pmw=7gHKLjOuQ@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: samsung: fix suspend/resume functionality
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Mon, May 20, 2013 at 4:47 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Looks good to me.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> How are you going to merge this?
>
> Samsung tree?
>
> My pinctrl development tree?
>
> Or my fixes tree, if it's a regression for v3.10?

It is a regression for v3.10 so it would be nice to get it in there
(Tomasz's patches, too).

It looks like the majority of recent commits to this file went through
your tree and that seems fine to me unless anyone else on this thread
has objections.

Thanks!

-Doug
