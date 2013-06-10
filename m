Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3FJMwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:52:15 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42050 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FJMwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:52:14 -0400
MIME-Version: 1.0
In-Reply-To: <201306090159.05383.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
Date: Mon, 10 Jun 2013 14:52:13 +0200
Message-ID: <CACRpkdaV0ipY4mYHt998D=NNKrpDaFhCA949V0-93NkOKcvHyA@mail.gmail.com>
Subject: Re: [PATCH 0/2] pinctrl: common handling of generic pinconfig props
 in dt
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 1:59 AM, Heiko Stübner <heiko@sntech.de> wrote:

> following your suggestions for a common handling of things like pulls in dt,
> I've come up with the following solution - hopefully I've gotten the correct
> meaning of your explanaitions.
>
> It handles all the pinconfigs that either ignore the argument, or have very
> simple one, like PIN_CONFIG_OUTPUT does.

OK patches applied. It needs some rough fixes like NULL check
on kmalloc() but it'll do for a starter. Now I can tell everyone to
use this and refer to it.

> I've also attached my current rockchip pinctrl driver to show how it is using
> this currently.

OK I might just merge it. If you take the rest of the patches through
ARM SoC they will need to pull in my tree anyway if it's intended to
go in this merge window.

Yours,
Linus Walleij
