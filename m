Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3GTRqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:46:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41680 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3GTRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:46:49 -0400
MIME-Version: 1.0
In-Reply-To: <51DE617E.3060908@atmel.com>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	<1373471889-18107-11-git-send-email-wsa@the-dreams.de>
	<51DE617E.3060908@atmel.com>
Date: Sat, 20 Jul 2013 19:46:48 +0200
Message-ID: <CACRpkdYnPN3sm8x9B02bkTuR3oufrng60YU-XeG4fA28J_B_ww@mail.gmail.com>
Subject: Re: [PATCH 11/12] drivers/tty/serial: don't use devm_pinctrl_get_select_default()
 in probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 9:40 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> On 10/07/2013 17:57, Wolfram Sang :
>
>> Since commit ab78029 (drivers/pinctrl: grab default handles from device
>> core),
>> we can rely on device core for setting the default pins. Compile tested
>> only.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> ---
>>   drivers/tty/serial/atmel_serial.c |    8 --------
>
>
> For atmel_serial.c:
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Greg can you please apply this to the TTY tree if it looks
OK to you?

Yours,
Linus Walleij
