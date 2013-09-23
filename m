Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3IWHsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:48:33 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:63280 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3IWHsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <1378196941-23390-2-git-send-email-sonic.adi@gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<1378196941-23390-2-git-send-email-sonic.adi@gmail.com>
Date: Mon, 23 Sep 2013 09:48:31 +0200
Message-ID: <CACRpkdaZNd55GLb+kx6ieZRbm=S+8s=izrzew2xH+vkYvdjOpQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 v4] blackfin: gpio: Remove none gpio lib code.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 10:29 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> - Remove non gpio lib code from blackfin architecture.
> - Limit the lagecy blackfin gpio driver to bf5xx processors only.
> - Remove unused definition of the pint power functions.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Hi Sonic, I tried to apply this but it doesn't apply cleanly on
my pinctrl "devel" branch based off v3.12-rc1.

Can you rebase patch 2+3 and resend?

Yours,
Linus Walleij
