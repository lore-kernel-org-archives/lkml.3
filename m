Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3CGDkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:40:13 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:43361 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CGDkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:40:12 -0500
MIME-Version: 1.0
In-Reply-To: <1362376059.414.1.camel@phoenix>
References: <1362376059.414.1.camel@phoenix>
Date: Thu, 7 Mar 2013 04:40:11 +0100
Message-ID: <CACRpkdZ4KyCxOOTfJtyUiRCwBUC44iJiqWanoTs9FYgbwnhHVw@mail.gmail.com>
Subject: Re: [PATCH RFT] pinctrl: single: Fix build error
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 6:47 AM, Axel Lin <axel.lin@ingics.com> wrote:

> If pcs->is_pinconf is false, it means does not support pinconf.
> If pcs->is_pinconf is true, is_generic flag is always true.
>
> This patch fixes below build error:
>
>   CC [M]  drivers/pinctrl/pinctrl-single.o
> drivers/pinctrl/pinctrl-single.c: In function 'pcs_probe':
> drivers/pinctrl/pinctrl-single.c:1441:3: error: assignment of member 'is_generic' in read-only object
> make[2]: *** [drivers/pinctrl/pinctrl-single.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied with Haojian's ACK, thanks!

Yours,
Linus Walleij
