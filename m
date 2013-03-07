Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3CGCfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:35:47 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:52998 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab3CGCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:35:46 -0500
MIME-Version: 1.0
In-Reply-To: <1362275632-20242-3-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
	<1362275632-20242-3-git-send-email-cesarb@cesarb.net>
Date: Thu, 7 Mar 2013 03:35:45 +0100
Message-ID: <CACRpkdZ4he9BFCJ3ta59ZUsNZ=F88o8iR_y5B5Rk=EgrfZVZsg@mail.gmail.com>
Subject: Re: [PATCH 02/14] MAINTAINERS: remove arch/arm/plat-nomadik/
From: Linus Walleij <linus.walleij@linaro.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Alessandro Rubini <rubini@unipv.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 2:53 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> The files within that directory were moved to other places over the
> course of several commits. I only added the ones moved in the patch
> series which finally removed the directory; untangling the rest will
> take more work, since some seem to be shared with ux500.
>
> In fact, the ARM/Ux500 ARM ARCHITECTURE block has patterns for files
> named "nomadik" too. The patterns in this pair of MAINTAINER blocks
> really need a review from the respective maintainters.
>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Thanks for doing this Cesar!

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

The reason some drivers are named "Nomadik" is that that
platform was the first using that IP block, but in some cases
like drivers/i2c/busses/i2c-nomadik.c the original platform has
not yet been migrated to it.

Yours,
Linus Walleij
