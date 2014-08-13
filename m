Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaHMIy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:54:56 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52635 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaHMIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <53EAF444.8050507@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
	<1407845080-8353-1-git-send-email-srinivas.kandadgatla@linaro.org>
	<20140812141242.GI30401@n2100.arm.linux.org.uk>
	<53EAF444.8050507@linaro.org>
Date: Wed, 13 Aug 2014 10:54:52 +0200
Message-ID: <CACRpkdaWkTp399GoHRifVQJE8WNrYf4GWyThMEg6ZVuy9_H=Tg@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] mmc: mmci: relax blksz check for SDIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 7:14 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:

> In the past Ulf Hansson and Stefan Nilsson have submitted a patch to fix
> this issue for ux500v2. This patch adds new flag non_power_of_2_blksize /
> any_blksize to variant_data.

That's the right approach. It makes non-2^n support the exception rather
than the rule and applies only to the variants relevant so the logic is right.

Yours,
Linus Walleij
