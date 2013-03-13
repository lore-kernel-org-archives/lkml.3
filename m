Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127Ab3CMTDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:03:54 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33629 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab3CMTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <1363163037-23995-1-git-send-email-haojian.zhuang@linaro.org>
References: <1363163037-23995-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 13 Mar 2013 20:03:53 +0100
Message-ID: <CACRpkdasacB-jVtzgKimEWhf0Xhm8u5jAQgN6EqNLkEE_htUrg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: remove pxa pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:23 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:

> pinctrl-pxa driver doesn't support well on DT mode. Now pinctrl-single
> could support DT mode & pin configuration. Use pinctrl-single driver to
> support MMP/PXA silicons instead.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Is the switch to pinctrl-single already done for these platforms,
i.e. the device trees are updated to contain pinctrl-single data?

And is ATAG code path removed, so noone needs the old driver?

And is the defconfig or Kconfig for PXA/MMP altered to select
the single driver instead?

Else I cannot merge it...

Yours,
Linus Walleij
