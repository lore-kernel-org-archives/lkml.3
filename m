Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3EXHo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:44:57 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45557 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970Ab3EXHo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <1368702935-25599-1-git-send-email-lee.jones@linaro.org>
References: <1368702935-25599-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 24 May 2013 09:44:55 +0200
Message-ID: <CACRpkdZjC7nFxsWkED6FvCOxdA1oQVuB+Tz8DZWM+iQDi6zjWA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Only configure wake-up reasons on ux500 based platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 1:15 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Multiplatform calls all enabled platforms' initcalls. In the
> ux500_idle_init() initcall we call into the DBx500-PRCMU which in turn
> executes some ux500 specific register reads/writes. When running on
> some !ux500 platforms this ends up causing a kernel Oops. This patch
> ensures the PRCMU call is only invoked when running on ux500 based
> platforms.
>
> Reported-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied for ux500 fixes.

Hm, again and again I get so confused by this, don't you say
"wakeup CAUSE" rather than "wakeup REASON"?

Maybe I don't know the anglo saxon well enough...

Yours,
Linus Walleij
