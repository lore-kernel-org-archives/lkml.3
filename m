Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3DWK7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:59:52 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:41297 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3DWK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130404073340.GA6892@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-5-git-send-email-lee.jones@linaro.org>
	<CACRpkdbh-DJti2ny=uBe-b_vGkQBNL=emMuZ6+_cE5jvRsA4sA@mail.gmail.com>
	<20130404073340.GA6892@gmail.com>
Date: Tue, 23 Apr 2013 12:59:50 +0200
Message-ID: <CACRpkdYLJyvCK33pAHeOkXfBOiPJGAZ9bV+s-cJanfOXz+VTOg@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Over-ride TCDM size when booting the DB8540 platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 9:33 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The PRCMU's Tightly Coupled Data Memory on the DB8540 platform is
> 8kB larger than it's predecessor's. We need to reflect that in its
> Device Tree. By re-specifying the address and size of the device
> we effectively over-ride the previous values with more accurate
> ones.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

As mentioned this patch does not apply. Some whitespace trouble.

And please squash it into the patch adding the ccu8540, 3/9.

Yours,
Linus Walleij
