Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153Ab3ECULE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:11:04 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:63427 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762324Ab3ECULA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-16-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-16-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:11:00 +0200
Message-ID: <CACRpkdZXTdkTkE2xW=ktuiTHddxJeqNkVwKFT3LnsitCjsTmQw@mail.gmail.com>
Subject: Re: [PATCH 15/63] ARM: ux500: Remove unused 'data_width' attributes
 from UART DMA configs
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA configuration data is now allocated in the UART driver, so these
> are just ignored.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-dma40 branch.

Thanks!
Linus Walleij
