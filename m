Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3DCUjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:39:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56944 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3DCUju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-5-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-5-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:39:50 +0200
Message-ID: <CACRpkdbh-DJti2ny=uBe-b_vGkQBNL=emMuZ6+_cE5jvRsA4sA@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: ux500: Over-ride TCDM size when booting the
 DB8540 platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The PRCMU's Tightly Coupled Data Memory on the DB8540 platform is
> 8kB larger than it's predecessor's. We need to reflect that in its
> Device Tree. By re-specifying the address and size of the device
> we effectively over-ride the previous values with more accurate
> ones.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Need to change the name of the file it hits to ccu8540 before
it applies...

Yours,
Linus Walleij
