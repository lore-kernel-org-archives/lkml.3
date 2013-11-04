Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3KDLuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:50:46 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45613 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3KDLup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-5vqN_ywFRM_SCW5OkiHpXWNf-fhHEmBHnS-HwQp-kxQ@mail.gmail.com>
References: <CAPgLHd-5vqN_ywFRM_SCW5OkiHpXWNf-fhHEmBHnS-HwQp-kxQ@mail.gmail.com>
Date: Mon, 4 Nov 2013 12:50:44 +0100
Message-ID: <CACRpkdZoTTOstUZ7ectG4MRZ6De+oCZahJ0L7dSLbBt+5nTF9w@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: imx1: fix return value check in imx1_pinctrl_core_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 8:51 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function devm_ioremap_nocache() returns NULL
> pointer not ERR_PTR(). The IS_ERR() test in the return value check
> should be replaced with NULL test.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.

I don't know why I miss such things during review all the time :-(

Anyway it is great that you fix it up!

Yours,
Linus Walleij
