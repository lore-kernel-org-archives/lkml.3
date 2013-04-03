Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354Ab3DCUoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:44:16 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:59978 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603Ab3DCUoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-7-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-7-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:44:14 +0200
Message-ID: <CACRpkdaVWUq5dQ7ktGAhSmKkWs7DvKrHtQng106ccD27hp_HuQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] ARM: ux500: Add a VQMMC (level-shifting) regulator DT
 node for Snowball
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

> Until recently platform code took care of all MMCI level-shifting by
> way of an ios_handler() call-back. Now it is the driver's responsibility
> to handle. In order to so that we need to provide the VQMMC regulator
> reference in Device Tree. This patch takes care of that.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied, thanks!

Yours,
Linus Walleij
