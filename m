Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab3DYMEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:04:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45979 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:04:38 -0400
MIME-Version: 1.0
In-Reply-To: <1366280825-31136-10-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-10-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 14:04:38 +0200
Message-ID: <CACRpkdafij8an62xwcZ=TeF7a9Sv6MAuF3RHtkjhrStTygw7PQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM: ux500: Register Cyrp and Hash platform drivers
 on Snowball
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

> These drivers are now operational and even use the latest common clk
> and DMA APIs. There's no reason why we shouldn't start them up now.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
