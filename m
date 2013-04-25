Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3DYMC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:02:59 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54736 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <1366280825-31136-8-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-8-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 14:02:58 +0200
Message-ID: <CACRpkdaXGGXvjakokLfXTrw5YmdGY9TNs1XO6XF370QQC4Z6Dw@mail.gmail.com>
Subject: Re: [PATCH 7/9] ARM: ux500: Stop passing Cryp DMA channel config
 information though pdata
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

On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA channel configuration information should be setup in the driver.
> The Ux500 Cryp driver now does this, so there's no need to send it
> though here too.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Provided the deps are in place:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
