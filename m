Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283Ab3DBI0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:26:15 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44040 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761249Ab3DBI0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
Date: Tue, 2 Apr 2013 10:26:12 +0200
Message-ID: <CACRpkdYgCxf9R1aU2QdPUBxErhK=E2tM=6L-yMLA_L3+ntj3nQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: update V-INTCORE constraints
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 4:21 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Update V-INTCORE regulator constraints to allow voltage and
> configuration changes from consumer drivers.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
> Hi Linus,
>
> this patch adds the regulators bits I'm missing for ux500-musb patches.
> Without this I just get a runtime warning like:
>
> V-INTCORE: operation not allowed
>
> but the driver works anyway and there are no build dependencies, so I
> think this can safely go in the arm-soc tree on its own, and the whole
> thing should work happily in -next.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I know that Lee's been sending off a large set of regulator patches
lately, some include alterations to this platform config.

Maybe it's better to take this patch into the regulator tree if these
machine configs will come in that way? Also like Lee to have a
look at this...

Yours,
Linus Walleij
