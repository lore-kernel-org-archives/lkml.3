Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3DYNIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:08:43 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:62123 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3DYNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130424150521.GE9652@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-6-git-send-email-lee.jones@linaro.org>
	<20130424150521.GE9652@gmail.com>
Date: Thu, 25 Apr 2013 15:08:41 +0200
Message-ID: <CACRpkdac6zF0fZfGCkXDAKqc+ZtxvU4RXYMurgcM9612Xj07Yw@mail.gmail.com>
Subject: Re: [PATCH 05/10 v2] usb: musb: ux500: attempt to find channels by
 name before using pdata
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 5:05 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If we can ever get to a state where we can solely search for DMA channels
> by name, this will almost completely alleviate the requirement to pass
> copious amounts of information though platform data. Here we take the
> first step towards this. The next step will be to enable Device Tree
> complete with name<->event_line mapping.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looking good, would be nice if Arnd checked it tho.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
