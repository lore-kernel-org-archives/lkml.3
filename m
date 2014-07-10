Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaGJLNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:13:13 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:60943 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGJLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:13:11 -0400
Date: Thu, 10 Jul 2014 13:12:53 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@linaro.org>, Olof Johansson <olof@lixom.net>,
        Dongjin Kim <tobetter@gmail.com>, Julius Werner <jwerner@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] usb: usb5303: make use of uninitialized err variable
Message-ID: <20140710111253.GA5352@lianli>
References: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
 <20140709224647.GA23929@kroah.com>
 <CAMuHMdVq3BX=NwaCsma-N5iTdTkCS-rsX16dQL1Qr9Sepo8qww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVq3BX=NwaCsma-N5iTdTkCS-rsX16dQL1Qr9Sepo8qww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg and Geert,

On Thu, Jul 10, 2014 at 09:38:00AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Thu, Jul 10, 2014 at 12:46 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jun 02, 2014 at 07:45:25PM +0200, Emil Goode wrote:
> >> The variable err is not initialized here, this patch uses it
> >> to store an eventual error value from devm_clk_get().
> >>
> >> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> >> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> ---
> >>  drivers/usb/misc/usb3503.c |   10 +++++++---
> >>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> > This patch fails to apply to my tree :(
> 
> You've already applied
> commit ec5734c41bee2ee7c938a8f34853d31cada7e67a
> Author: Tushar Behera <tushar.b@samsung.com>
> Date:   Tue Jun 17 16:38:50 2014 +0530
> 
>     usb: misc: usb3503: Update error code in print message
> 
>     'err' is uninitialized, rather print the error code directly.
> 
> which fixes it slightly different.

Yes, my patch was sent about two weeks earlier, but of course please pick
the one you think is best.

Best regards,

Emil Goode
