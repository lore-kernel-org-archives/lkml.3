Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab3DYNGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:06:09 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64565 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab3DYNGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130424150406.GD9652@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-5-git-send-email-lee.jones@linaro.org>
	<20130424150406.GD9652@gmail.com>
Date: Thu, 25 Apr 2013 15:06:06 +0200
Message-ID: <CACRpkdZY7bEH36mMo3fggTuyOhWe-E-YF=BUCt4zBReOzPuk-Q@mail.gmail.com>
Subject: Re: [PATCH 04/10 v2] usb: musb: ux500: harden checks for platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 5:04 PM, Lee Jones <lee.jones@linaro.org> wrote:

> In its current state, the ux500-musb driver uses platform data pointers
> blindly with no prior checking. If no platform data pointer is passed
> this will Oops the kernel. In this patch we ensure platform data and
> board data are present prior to using them.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
