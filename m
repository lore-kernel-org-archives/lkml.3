Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3GTRpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:45:44 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:34428 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3GTRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <201307110113.58681.arnd@arndb.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	<1373471889-18107-3-git-send-email-wsa@the-dreams.de>
	<201307110113.58681.arnd@arndb.de>
Date: Sat, 20 Jul 2013 19:45:42 +0200
Message-ID: <CACRpkdbeFGsvGENOEqAOVSP_GH4cAni+zYXA8eF3CKj1OudesQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] drivers/misc: don't use devm_pinctrl_get_select_default()
 in probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 1:13 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 10 July 2013, Wolfram Sang wrote:
>> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
>> we can rely on device core for setting the default pins. Compile tested only.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I think that the idea is to merge this through respective subsystem.
Greg, can you take this into your misc-char tree?

Yours,
Linus Walleij
