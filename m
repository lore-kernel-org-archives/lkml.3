Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbaCEBwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:52:31 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36244 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbaCEBw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:52:29 -0500
MIME-Version: 1.0
In-Reply-To: <1393418614-3968549-3-git-send-email-arnd@arndb.de>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
	<1393418614-3968549-3-git-send-email-arnd@arndb.de>
Date: Wed, 5 Mar 2014 09:52:29 +0800
Message-ID: <CACRpkdaBMozNayXXyn8Ag+GUU_+C2j4X7aVuaZjgV_krCvSy0A@mail.gmail.com>
Subject: Re: [PATCH 2/5] gpio: remove obsolete tnetv107x driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Cyril Chemparathy <cyril@ti.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 8:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The tnetv107x platform is getting removed, so this driver won't
> be needed any more.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org

Can I have an ACK from some Sekhar to apply this
to the GPIO tree, so we are all aligned?

Or do you want my ACK to take this through ARM SoC?
In that case Acked-by...

Yours,
Linus Walleij
