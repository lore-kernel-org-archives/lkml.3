Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3FDJiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:38:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48560 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3FDJh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:37:58 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCHv2] Add TI-Nspire timer support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <CACRpkdbx1xugH_T6KBnui=JtoheH9H6=iv5yR1oejc_WxUfdkQ@mail.gmail.com>
Date: Tue, 4 Jun 2013 19:37:47 +1000
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <347F9A91-70C0-4CD4-B0F6-C5E1DB0C3784@gmail.com>
References: <AE2AF524-C495-4D6B-B622-816B3254D384@gmail.com> <CACRpkdbx1xugH_T6KBnui=JtoheH9H6=iv5yR1oejc_WxUfdkQ@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/06/2013, at 7:36 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> On Sat, Jun 1, 2013 at 8:02 AM, Daniel Tang <dt.tangr@gmail.com> wrote:
> 
>> The interrupt acknowledgement mechanism is a little strange because the interrupt mask and acknowledge registers are located in another memory mapped I/O peripheral. The address of this register is passed to the driver through device tree bindings.
> 
> I can't see any linebreaks there. This looks horrible in git log.
> 
> But I guess Daniel can fix it up directly in his tree.
> 

Apologies, I can fix it up if it needs be.

> Yours,
> Linus Walleij

Cheers,
Daniel Tang