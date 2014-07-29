Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaG2Ucx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:32:53 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:65423 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaG2Ucw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:32:52 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 29 Jul 2014 22:31:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140729203145.GM12963@localhost>
References: <20140729165709.GA3380@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729165709.GA3380@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:57:09AM +0800, Wang YanQing wrote:
> PL2303HX has two GPIOs, this patch add interface for it.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Changes v5-v6:
>  1: fix typo error in Kconfig reported by Andreas Mohr
>  2: add const qulification to gpio_dir_mask and gpio_value_mask suggested by Andreas Mohr
> 
>  Hi, Linus Walleij, I see you give your review-by to v4, but v4
>  has a obvious bug (template_chip overwrite label's value), so
>  could you review this version? Thanks!
> 
>  Greg KH, although I really hope this is the last version, 
>  but what is your suggestion?
>  
>  Thanks again for all guys' review and correction.

I haven't had a chance to look at this patch yet due to travels.
Hopefully I should be able to provide some feedback within the next few
days.

Johan
