Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaIWPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:42:18 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:42799 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaIWPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <1411030649.2017.7.camel@x220>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	<53C67783.4090407@samsung.com>
	<1409825317.5546.94.camel@x220>
	<201409041803.46098.arnd@arndb.de>
	<1411030649.2017.7.camel@x220>
Date: Tue, 23 Sep 2014 17:42:16 +0200
Message-ID: <CACRpkdZ8ZnD7t+QKTD9MkN7AWXtcNbO8H382-V6KeLcXG_MHkA@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: Remove remaining check for CONFIG_S5P_GPIO_DRVSTR
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:57 AM, Paul Bolle <pebolle@tiscali.nl> wrote:

> From: Paul Bolle <pebolle@tiscali.nl>
>
> Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
> removed the Kconfig symbol S5P_GPIO_DRVSTR. It didn't remove one check
> for the related macro. Remove that check and the dead code it hides.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Patch applied with Tomasz Review tag.

Yours,
Linus Walleij
