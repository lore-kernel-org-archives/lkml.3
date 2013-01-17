Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3AQKqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:46:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63733 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3AQKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130110133818.GA22710@balto.lan>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
	<CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
	<20130110133818.GA22710@balto.lan>
Date: Thu, 17 Jan 2013 11:46:30 +0100
Message-ID: <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 2:38 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Thu, Jan 10, 2013 at 12:23:32PM +0100, Linus Walleij wrote:
>> On Mon, Jan 7, 2013 at 5:47 PM, Fabio Baltieri
>> <fabio.baltieri@linaro.org> wrote:
>>
>> > This patch converts the module to use clk_prepare_enable and
>> > clk_disable_unprepare variants as required by common clock framework.
>> >
>> > Without this the system crash during probe function.
>> >
>> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Thanks for the ACK.  This bug was here unnoticed since 3.6 merge window,

Then it should have Cc: stable@kernel.org..

> do you think it may make sense to add this driver to u8500_defconfig?  I
> can send a patch if you say so...

Yes, can you make a patch updating the defconfig and also enabling
a few other things like charging maybe? Sync with Lee.

Yours,
Linus Walleij
