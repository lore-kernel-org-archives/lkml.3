Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3FQLWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:22:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37434 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab3FQLWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <1371463695-21252-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371463695-21252-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 17 Jun 2013 13:22:30 +0200
Message-ID: <CACRpkdb_AKomxOQA_tN4kev8v5paPtm_M5WGR+drhO6n37AKKQ@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: remove unused ret and pins_state variables
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:08 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Removes the warnings:
>
> drivers/spi/spi-pl022.c: In function 'pl022_suspend_resources':
> drivers/spi/spi-pl022.c:2322:24: warning: unused variable 'pins_state' [-Wunused-variable]
> drivers/spi/spi-pl022.c:2321:6: warning: unused variable 'ret' [-Wunused-variable]
> drivers/spi/spi-pl022.c: In function 'pl022_resume_resources':
> drivers/spi/spi-pl022.c:2334:6: warning: unused variable 'ret' [-Wunused-variable]
>
> introduced in:
>
> f1c9cf0 spi: pl022: use pinctrl PM helpers
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

How sloppy of me. Applied with Mark's ACK.

Thanks!
Linus Walleij
