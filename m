Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3DYIpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:45:49 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:51045 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3DYIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-12-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-12-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 10:45:47 +0200
Message-ID: <CACRpkdZLEn9sui9H8CzrdO9YcxhsqBeU_6aqkWsPaR-=h9014A@mail.gmail.com>
Subject: Re: [PATCH 11/32] ARM: ux500: Remove unused 'data_width' attributes
 from UART DMA configs
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

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA configuration data is now allocated in the UART driver, so these
> are just ignored.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
