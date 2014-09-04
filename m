Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaIDQre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:47:34 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:50380 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaIDQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <1409397180-32736-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409397180-32736-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Thu, 4 Sep 2014 18:47:32 +0200
Message-ID: <CACRpkdZUAGBdP_FhGAUkKVOS5qo=1H4o+viU7oBQpC+5HfSqWA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: Remove gpiochip on failure cases
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <Baohua.Song@csr.com>, Rongjun Ying <rongjun.ying@csr.com>,
        Yuping Luo <yuping.luo@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 1:13 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch releases gpiochip related resources by calling
> gpiochip_remove when gpiochip_irqchip_add fails.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Barry Song <Baohua.Song@csr.com>
> CC: Rongjun Ying <rongjun.ying@csr.com>
> CC: Yuping Luo <yuping.luo@csr.com>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied.

Yours,
Linus Walleij
