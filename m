Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3F0Idi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:33:38 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46660 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3F0Ide (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8wYkHaqH90Xyg=QgBKaREwjgS=H-pOMz-jLrwtdWuQ3g@mail.gmail.com>
References: <CAPgLHd8wYkHaqH90Xyg=QgBKaREwjgS=H-pOMz-jLrwtdWuQ3g@mail.gmail.com>
Date: Thu, 27 Jun 2013 10:33:34 +0200
Message-ID: <CACRpkdZ4U+FWAu8u40cb-LPPO1G-O76w7GB08YXAepdRzrJedg@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: vt8500: wmt: remove redundant dev_err call
 in wmt_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, Axel Lin <axel.lin@ingics.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@nvidia.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:56 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied with Tony's ACK.

Yours,
Linus Walleij
