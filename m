Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaGON53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:57:29 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55865 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaGON50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <1405350546-28467-4-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
	<1405350546-28467-1-git-send-email-sam@ravnborg.org>
	<1405350546-28467-4-git-send-email-sam@ravnborg.org>
Date: Tue, 15 Jul 2014 21:57:24 +0800
Message-ID: <CAF0htA7-_50ctd9PwpGiWNVMjehomaOh1UK2f9zgwW7T+40NDg@mail.gmail.com>
Subject: Re: [PATCH 04/38] score: drop irrelevant assignment from Kbuild file
From: Lennox Wu <lennox.wu@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Chen Liqin <liqin.linux@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks :)

Acked-by: Lennox Wu<lennox.wu@gmail.com>


2014-07-14 23:08 GMT+08:00 Sam Ravnborg <sam@ravnborg.org>:
> header-y assignemnt in this file has no effect - drop it.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Chen Liqin <liqin.linux@gmail.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/score/include/asm/Kbuild | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
> index 2f947ab..f67b3f6 100644
> --- a/arch/score/include/asm/Kbuild
> +++ b/arch/score/include/asm/Kbuild
> @@ -1,7 +1,4 @@
>
> -header-y +=
> -
> -
>  generic-y += barrier.h
>  generic-y += clkdev.h
>  generic-y += cputime.h
> --
> 1.9.3
>
