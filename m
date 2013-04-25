Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3DYNPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:15:22 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51294 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3DYNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-10-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-10-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:15:19 +0200
Message-ID: <CACRpkdbKDoTscjxhHw7hTG2xZn_AJa23o19dQcLB7vAdZ156WQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] ARM: ux500: Remove ux500-musb platform registation
 when booting with DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now the ux500-musb driver has been enabled for Device Tree, there is no
> requirement to register it from platform code.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
