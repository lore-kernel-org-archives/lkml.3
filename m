Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3HGNaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:30:39 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43798 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3HGNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <1374243229-8585-4-git-send-email-lee.jones@linaro.org>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
	<1374243229-8585-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 7 Aug 2013 15:30:38 +0200
Message-ID: <CACRpkdb8==w8EFVQqzP-Bc-CJefV8igEN1JE_=sRvHeW+cMDhw@mail.gmail.com>
Subject: Re: [PATCH 03/13] ARM: ux500: Remove Snowball DTS entry for TPS61052 chip
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

On Fri, Jul 19, 2013 at 4:13 PM, Lee Jones <lee.jones@linaro.org> wrote:

> TPS61052 is a; boost converter, LED driver, LED flash driver and
> simple GPIO pin chip. It has no use here however, as it is not
> found on the Snowball development board.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij
