Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3DTNTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:19:46 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:62580 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3DTNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <1366463287-9922-1-git-send-email-linus.walleij@linaro.org>
References: <1366463287-9922-1-git-send-email-linus.walleij@linaro.org>
Date: Sat, 20 Apr 2013 15:19:43 +0200
Message-ID: <CACRpkdYWSM0BK77qWbQWh0xsN+Ps95Q70zG-GE98MYvThrky2A@mail.gmail.com>
Subject: Re: [PATCH 1/4] clocksource: nomadik-mtu: fix up clocksource/timer
From: Linus Walleij <linus.walleij@linaro.org>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM SoC folks:

On Sat, Apr 20, 2013 at 3:08 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> The Nomadik clocksource driver has had a bad define making it
> impossible to use it for sched_clock() for a while. Fix this
> and also enable it for the Nomadik.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

This one should go to fixes ASAP, could you pick it to your fixes
branch? It could be tagged stable if desired - this only affects the
Nomadik which works just OK on jiffies so it's really no big regression.
The Ux500 does not use the MTU for sched_clock().

Yours,
Linus Walleij
