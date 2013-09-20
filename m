Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3ITUlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:41:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52834 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3ITUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <1379506478-16625-31-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
	<1379506478-16625-31-git-send-email-lee.jones@linaro.org>
Date: Fri, 20 Sep 2013 22:41:15 +0200
Message-ID: <CACRpkdb01+MCUY1zaoTJ_o5yqaZFNJMH91kc4F6mMu+Oyg--Vg@mail.gmail.com>
Subject: Re: [PATCH 30/41] usb: musb: ux500: Don't supply a con_id when
 requesting the clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Felipe Balbi <balbi@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If we supply a con_id then the clock framework will search for that name
> in MUSB's Device Tree node for the 'clock-names' property. If it's absent
> the clock request will fail. However, if we don't supply the con_id then
> clk_get() will call into clk_sys() which will use the device name to
> search for the appropriate clock, which is much more natural than forcing
> 'usb'.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks fine to me, Felipe can we have your ACK on this so I can take
this with the rest of the clock stuff through ARM SoC?

Yours,
Linus Walleij
