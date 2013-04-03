Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342Ab3DCUe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:34:26 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40351 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762534Ab3DCUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-3-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:34:24 +0200
Message-ID: <CACRpkdafSvT5Xb=7sqnkRHcc4UKkVzr8jzThMgWn6459RDmKGw@mail.gmail.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Supply a DTS file for the u8540 platform
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

> This is a skeleton DTS file which only enables serial. Just using
> this simple file yields a terminal when booting u8540.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/u8540.dts |   36 ++++++++++++++++++++++++++++++++++++

Please rename this DTS file ccu8540.dts.

Yours,
Linus Walleij
