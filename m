Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3CUSHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:07:30 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50933 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3CUSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <1363820051-24428-10-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
	<1363820051-24428-10-git-send-email-robherring2@gmail.com>
Date: Thu, 21 Mar 2013 19:07:28 +0100
Message-ID: <CACRpkdbCcvjnL4g9iUJm+1dxs28VhGnc_ibyARZNVP3MFRmNmQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] ARM: integrator-cp: convert use CLKSRC_OF for timer init
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:54 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> Move the integrator-cp timer init to timer-sp.c and use CLKSRC_OF. There is
> no reason to use the aliases, so drop them from the init code.
>
> The integrator-cp timers are mistakenly called sp804 timers in the dts, but
> in fact they are not sp804 dual timers, but single timers with the same
> programming model. Fix the dts to reflect this.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Looks correct to me. Throw it into linux-next and I'll
test if it works too! :-)
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
