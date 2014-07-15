Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaGOJWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:22:24 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:18357 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaGOJWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:22:18 -0400
Message-ID: <53C4F2C6.8050303@imgtec.com>
Date: Tue, 15 Jul 2014 10:22:14 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 23/38] metag: clean-up uapi Kbuild file
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-23-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-23-git-send-email-sam@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 16:08, Sam Ravnborg wrote:
> Remove redundant assignments.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: James Hogan <james.hogan@imgtec.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks!
James

> ---
>  arch/metag/include/uapi/asm/Kbuild | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
> index ab78be2..1f7f43f 100644
> --- a/arch/metag/include/uapi/asm/Kbuild
> +++ b/arch/metag/include/uapi/asm/Kbuild
> @@ -1,14 +1,9 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -header-y += byteorder.h
>  header-y += ech.h
> -header-y += ptrace.h
> -header-y += sigcontext.h
> -header-y += siginfo.h
> -header-y += swab.h
> -header-y += unistd.h
>  
> +# Wrappers from asm-generic
>  generic-y += mman.h
>  generic-y += resource.h
>  generic-y += setup.h
> 
