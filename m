Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3BGTKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:10:40 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50027 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab3BGTKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3jHe+mP0dU_BHThBV-va_iJLcFQedmWQOTaYafAZM1Yxg@mail.gmail.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
	<1360093715-6348-10-git-send-email-linus.walleij@stericsson.com>
	<5112F1B9.6010700@wwwdotorg.org>
	<CAF2Aj3jHe+mP0dU_BHThBV-va_iJLcFQedmWQOTaYafAZM1Yxg@mail.gmail.com>
Date: Thu, 7 Feb 2013 20:10:38 +0100
Message-ID: <CACRpkdYCqU0srgiboJnOTaOiG+9BCk-Kbe0-jscMMcnyKnVUDw@mail.gmail.com>
Subject: Re: [PATCH 09/14] pinctrl/abx500: use direct IRQ defines
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 10:01 AM, Lee Jones <lee.jones@linaro.org> wrote:

> I don't see myself on cc. Was that intentional?

No, it was my mistake...

> I quite like the idea of this.

Can I take it as an ACK? :-)

> Stephen,
>
> It doesn't mean the other patch was wrong, it just transfers the math.
>
> I wouldn't squash it into mine. I like the transition and the possibility to
> revert it if there's been some mistake.
>
> (not to say there is one, but just in case.)

I don't think it's wrong, just different. I changed
it after trying to subtract the offset in my head back
and forth a few times and screwed up the maths.

Yours,
Linus Walleij
