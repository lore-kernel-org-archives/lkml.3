Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab3DYNMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:12:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34043 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3DYNMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130424074336.GD17416@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-7-git-send-email-lee.jones@linaro.org>
	<20130424074336.GD17416@gmail.com>
Date: Thu, 25 Apr 2013 15:12:06 +0200
Message-ID: <CACRpkdbVRFow2PkZB6YQ-xR4n=YEQHgpekPTN997WnJj0WZwsw@mail.gmail.com>
Subject: Re: [PATCH 06/10 v2] usb: musb: ux500: add device tree probing support
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
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 9:43 AM, Lee Jones <lee.jones@linaro.org> wrote:

> usb: musb: ux500: add device tree probing support
>
> This patch will allow ux500-musb to be probed and configured solely from
> configuration found in Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This patch needs to be CC: devicetree-discuss.
But looks good to me!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
