Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3FDJgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:36:47 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58050 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3FDJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <AE2AF524-C495-4D6B-B622-816B3254D384@gmail.com>
References: <AE2AF524-C495-4D6B-B622-816B3254D384@gmail.com>
Date: Tue, 4 Jun 2013 11:36:42 +0200
Message-ID: <CACRpkdbx1xugH_T6KBnui=JtoheH9H6=iv5yR1oejc_WxUfdkQ@mail.gmail.com>
Subject: Re: [PATCHv2] Add TI-Nspire timer support
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 8:02 AM, Daniel Tang <dt.tangr@gmail.com> wrote:

> The interrupt acknowledgement mechanism is a little strange because the interrupt mask and acknowledge registers are located in another memory mapped I/O peripheral. The address of this register is passed to the driver through device tree bindings.

I can't see any linebreaks there. This looks horrible in git log.

But I guess Daniel can fix it up directly in his tree.

Yours,
Linus Walleij
