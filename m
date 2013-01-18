Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3ART2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:28:44 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:48799 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3ART2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <1357606429-23388-1-git-send-email-festevam@gmail.com>
References: <1357606429-23388-1-git-send-email-festevam@gmail.com>
Date: Fri, 18 Jan 2013 20:28:41 +0100
Message-ID: <CACRpkdZ5NVtPh0riOiQtkwcA=yqGt702D2bW28H7pv2obV5B_g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-mxs: Fix variables' definition type
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 1:53 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Fix the following warnings when building with W=1 option:
>
> drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_dt_free_map':
> drivers/pinctrl/pinctrl-mxs.c:151:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinctrl_enable':
> drivers/pinctrl/pinctrl-mxs.c:208:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinconf_group_set':
> drivers/pinctrl/pinctrl-mxs.c:265:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_pinctrl_parse_group':
> drivers/pinctrl/pinctrl-mxs.c:376:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks, applied with Shawn's ACK.

Yours,
Linus Walleij
