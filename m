Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3LLVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:09:19 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61601 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3LLVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <6e8200a86fb95c814f3f7211477547baab2efa73.1386855780.git.baruch@tkos.co.il>
References: <6e8200a86fb95c814f3f7211477547baab2efa73.1386855780.git.baruch@tkos.co.il>
Date: Thu, 12 Dec 2013 22:09:18 +0100
Message-ID: <CACRpkdZsdqaNmhgivw9WAv5PbBLRfNx5_UzKwG1A-mD0M5EEBQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add gpio subsystem git tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 2:43 PM, Baruch Siach <baruch@tkos.co.il> wrote:

> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 13c15c8..6e0c4eb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3767,6 +3767,7 @@ GPIO SUBSYSTEM
>  M:     Linus Walleij <linus.walleij@linaro.org>
>  S:     Maintained
>  L:     linux-gpio@vger.kernel.org
> +T:     git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git

This was already added some days back:
http://marc.info/?l=linux-gpio&m=138666513821506&w=2

But thanks anyway!

Yours,
Linus Walleij
