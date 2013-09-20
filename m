Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3ITU7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:59:48 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34087 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3ITU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <1379506478-16625-23-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
	<1379506478-16625-23-git-send-email-lee.jones@linaro.org>
Date: Fri, 20 Sep 2013 22:59:46 +0200
Message-ID: <CACRpkdZ+kg8VEMZ6gy6CG=YK0Ycj-Ud-UuRohzKgE4UW_VUMjg@mail.gmail.com>
Subject: Re: [PATCH 22/41] clk: ux500: Copy u8500_clk_init() ready for DT enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we're using the old clock initialisation function as a template.
> It's necessary to remove all of the clk_register_clkdev() calls as
> they don't make sense when booting with Device Tree.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I *really* like the looks of this! Mike can we have your ACK on this?

Yours,
Linus Walleij
