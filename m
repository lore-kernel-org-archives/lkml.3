Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaGNRxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:53:42 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:50701 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGNRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:53:33 -0400
Date: Mon, 14 Jul 2014 19:53:27 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 14/38] avr32: clean-up uapi Kbuild file
Message-ID: <20140714175327.GB28953@samfundet.no>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-14-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405350546-28467-14-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 14 Jul 2014 17:08:42 +0200 or thereabout, Sam Ravnborg wrote:
> Remove redundant assignments.
> 

Fantastic, reducing code is the best patches.

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/uapi/asm/Kbuild | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
> index 08d8a3d..6e33c08 100644
> --- a/arch/avr32/include/uapi/asm/Kbuild
> +++ b/arch/avr32/include/uapi/asm/Kbuild
> @@ -1,26 +1,9 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -header-y += auxvec.h
> -header-y += byteorder.h
>  header-y += cachectl.h
> -header-y += msgbuf.h
> -header-y += param.h
> -header-y += posix_types.h
> -header-y += ptrace.h
> -header-y += sembuf.h
> -header-y += setup.h
> -header-y += shmbuf.h
> -header-y += sigcontext.h
> -header-y += signal.h
> -header-y += socket.h
> -header-y += sockios.h
> -header-y += stat.h
> -header-y += swab.h
> -header-y += termbits.h
> -header-y += termios.h
> -header-y += types.h
> -header-y += unistd.h
> +
> +# Wrappers from asm-generic
>  generic-y += bitsperlong.h
>  generic-y += errno.h
>  generic-y += fcntl.h
-- 
mvh
Hans-Christian Egtvedt
