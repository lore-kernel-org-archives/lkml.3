Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaGWNZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:25:35 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34762 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaGWNZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <1405614579-4652-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405614579-4652-1-git-send-email-andrey.krieger.utkin@gmail.com>
Date: Wed, 23 Jul 2014 15:25:27 +0200
Message-ID: <CACRpkdZJQTBX00zBt418-Yqi7VsYF9epuB3WuzW=Y5vV0QOsaw@mail.gmail.com>
Subject: Re: [PATCH 4/4] drivers/pinctrl/qcom/pinctrl-msm.c: drop negativity
 check on unsigned value
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 6:29 PM, Andrey Utkin
<andrey.krieger.utkin@gmail.com> wrote:

> [linux-3.16-rc5/drivers/pinctrl/pinctrl-msm.c:145]: (style) Checking if
> unsigned variable 'mux_bit' is less than zero.
>
>     if (WARN_ON(g->mux_bit < 0))
>         return -EINVAL;
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80491
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Patch applied after fixing $SUBJECT, Björn protest if you don't like
it...

Yours,
Linus Walleij
