Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3HUWqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:46:49 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56875 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3HUWqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:46:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130821101448.GJ29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-22-git-send-email-lee.jones@linaro.org>
	<CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
	<20130821101448.GJ29850@lee--X1>
Date: Thu, 22 Aug 2013 00:46:47 +0200
Message-ID: <CACRpkdYjvFTJAUL6xKxjkVd_v=DHHRkswoB_eq0Npqj5Sw23KQ@mail.gmail.com>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 21 Aug 2013, Linus Walleij wrote:

>> Isn't it possible to fork a function u8500_clk_init_dt() to add all the
>> clocks in the DT probe path and keep this function
>> u8500_clk_init() as it is?
>
> Yes, we probably could do that, but as we're ripping out ATAG booting
> support from the ux500 platform, I'll just remove the
> clk_register_clkdev()s during the process.

I really do not like the approach of uglifying something and then
beautifying it later... I prefer each step in isolation to be good
looking, or you will be confused when traversing the history.

Yours,
Linus Walleij
