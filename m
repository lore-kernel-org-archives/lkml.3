Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaEHVJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:09:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64385 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbaEHVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <1399560990-1402858-5-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-5-git-send-email-arnd@arndb.de>
Date: Thu, 8 May 2014 23:09:14 +0200
Message-ID: <CACRpkdZK4XDxkQNjuDbaeptw3i6CEM_gaH8iWXu3inNN9WD3yg@mail.gmail.com>
Subject: Re: [PATCH] clk/versatile: export symbols for impd1
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 4:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The impd1 code on mach-integrator can be a loadable module,
> so we have to export icst_clk_register, integrator_impd1_clk_init
> and integrator_impd1_clk_exit.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
