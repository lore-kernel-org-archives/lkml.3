Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3GTRul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:50:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3GTRuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:50:39 -0400
Date: Sat, 20 Jul 2013 10:50:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 11/12] drivers/tty/serial: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20130720175049.GB5697@kroah.com>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
 <1373471889-18107-11-git-send-email-wsa@the-dreams.de>
 <51DE617E.3060908@atmel.com>
 <CACRpkdYnPN3sm8x9B02bkTuR3oufrng60YU-XeG4fA28J_B_ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYnPN3sm8x9B02bkTuR3oufrng60YU-XeG4fA28J_B_ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 07:46:48PM +0200, Linus Walleij wrote:
> On Thu, Jul 11, 2013 at 9:40 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > On 10/07/2013 17:57, Wolfram Sang :
> >
> >> Since commit ab78029 (drivers/pinctrl: grab default handles from device
> >> core),
> >> we can rely on device core for setting the default pins. Compile tested
> >> only.
> >>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> >> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> >> ---
> >>   drivers/tty/serial/atmel_serial.c |    8 --------
> >
> >
> > For atmel_serial.c:
> >
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Greg can you please apply this to the TTY tree if it looks
> OK to you?

Will do, thanks.

greg k-h
