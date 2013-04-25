Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3DYL4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:56:20 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:64140 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3DYL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <1366280825-31136-4-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-4-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:56:18 +0200
Message-ID: <CACRpkdZoTD1J7pSfpO37Xhj6NPn86N7fK0zP_dimGYm=B3AUMQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Stop passing Hash DMA channel config
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

On Thu, Apr 18, 2013 at 12:26 PM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA channel configuration information should be setup in the driver.
> The Ux500 Hash driver now does this, so there's no need to send it
> though here too.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

When 2/9 is fixed up:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
