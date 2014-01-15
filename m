Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAONv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:51:29 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54614 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAONvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <52D684E9.6080308@ti.com>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
	<1389700739-3696-7-git-send-email-wsa@the-dreams.de>
	<CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>
	<52D684E9.6080308@ti.com>
Date: Wed, 15 Jan 2014 14:51:25 +0100
Message-ID: <CACRpkdY1FuRoSFAPT8qUybzrizN_tEgxB41dwW_-uEWdFPb0jA@mail.gmail.com>
Subject: Re: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Cc: Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 1:54 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On Wednesday 15 January 2014 02:58 PM, Linus Walleij wrote:

>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> The DaVinci maintainers are queuing GPIO patches for their driver
>> for this merge window, so requesting them to apply this patch.
>
> I wont be sending any more pull requests for v3.14. Even if I send, the
> ARM-SoC maintainers will not take it anyway.

But as it is a fix I believe the ARM SoC maintainers will apply it
directly to the davinci branch.

Wolfram: I suggest you send this patch with my ACK directly
to arm@kernel.org and ask it to be applied to the davinci branch
in the ARM SoC tree.

Yours,
Linus Walleij
