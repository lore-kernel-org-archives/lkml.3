Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3IWJG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:06:29 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61808 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IWJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:06:28 -0400
MIME-Version: 1.0
In-Reply-To: <1378196941-23390-3-git-send-email-sonic.adi@gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<1378196941-23390-3-git-send-email-sonic.adi@gmail.com>
Date: Mon, 23 Sep 2013 11:06:28 +0200
Message-ID: <CACRpkdaX1eQw9=ze+i1UU2Ycun2B5yrG4nUNy22tTRB-krm38w@mail.gmail.com>
Subject: Re: [PATCH 3/3 v4] blackfin: pinctrl-adi2: Enable PINCTRL framework
 for BF54x and BF60x.
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
> - Remove unused macro MAX_RESOURCES
> - Override blackfin legacy peripheral pinmux request and free APIs by
> devm_pinctrl_get_select_default() to init the peripheral portmux setting.
>
> v3-chagnes:
> - Move pinctrl soc data out of blackfin arch folder.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Patch applied with Steven's ACK.

Yours,
Linus Walleij
