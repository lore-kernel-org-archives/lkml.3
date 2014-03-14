Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaCNJ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:28:36 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:51596 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaCNJ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403121555140.18573@ionos.tec.linutronix.de>
References: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com>
	<alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de>
	<CACRpkdZ6D1XfDBdJEcR8G2HWkNcZSfz08Yvx8f0s+CqTUmybkg@mail.gmail.com>
	<alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de>
	<CACRpkdb=51_D6kxWcmSSRdr3kROXiwJbRzQDS-1VxEJpBjVyUA@mail.gmail.com>
	<alpine.DEB.2.02.1403121555140.18573@ionos.tec.linutronix.de>
Date: Fri, 14 Mar 2014 10:28:34 +0100
Message-ID: <CACRpkdaDo5uQVWQ-BxLbGJcjQVYc7+oBczH3tUD1-syFi1oQfQ@mail.gmail.com>
Subject: Re: [PATCH] irq: Consider a negative return value of irq_startup() as
 an error
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> I pushed out the patch to a separate branch
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip irq/for-gpio
>
> and merged that branch back into irq/core.
>
> So you can just pull irq/for-gpio into the gpio work and base the gpio
> related changes on top of that. Just mention it in the pull request to
> the other Linus that it contains an irq/core change which avoids merge
> dependencies.

OK I first merged in the v3.14-rc6 as base and then pulled this in,
so I will proceed to switch the calls over to request/release
resources.

Yours,
Linus Walleij
