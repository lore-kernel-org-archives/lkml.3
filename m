Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaICLXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:23:21 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:47929 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaICLXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:23:17 -0400
Date: Wed, 3 Sep 2014 13:23:11 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [PATCH 17/38] cris: clean-up uapi Kbuild file
Message-ID: <20140903112311.GR27603@axis.com>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-17-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405350546-28467-17-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:08:45PM +0200, Sam Ravnborg wrote:
> Remove redundant assignments.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>

Don't see this patch in Linus tree yet, so if you want it, here's my

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

and thanks!

> ---
>  arch/cris/include/uapi/asm/Kbuild | 31 +------------------------------
>  1 file changed, 1 insertion(+), 30 deletions(-)
> 
> diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
> index 01f66b8..de41e86 100644
> --- a/arch/cris/include/uapi/asm/Kbuild
> +++ b/arch/cris/include/uapi/asm/Kbuild
> @@ -3,37 +3,8 @@ include include/uapi/asm-generic/Kbuild.asm
>  
>  header-y += ../arch-v10/arch/
>  header-y += ../arch-v32/arch/
> -header-y += auxvec.h
> -header-y += bitsperlong.h
> -header-y += byteorder.h
> -header-y += errno.h
> +
>  header-y += ethernet.h
>  header-y += etraxgpio.h
> -header-y += fcntl.h
> -header-y += ioctl.h
> -header-y += ioctls.h
> -header-y += ipcbuf.h
> -header-y += mman.h
> -header-y += msgbuf.h
> -header-y += param.h
> -header-y += poll.h
> -header-y += posix_types.h
> -header-y += ptrace.h
> -header-y += resource.h
>  header-y += rs485.h
> -header-y += sembuf.h
> -header-y += setup.h
> -header-y += shmbuf.h
> -header-y += sigcontext.h
> -header-y += siginfo.h
> -header-y += signal.h
> -header-y += socket.h
> -header-y += sockios.h
> -header-y += stat.h
> -header-y += statfs.h
> -header-y += swab.h
>  header-y += sync_serial.h
> -header-y += termbits.h
> -header-y += termios.h
> -header-y += types.h
> -header-y += unistd.h
> -- 
> 1.9.3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
