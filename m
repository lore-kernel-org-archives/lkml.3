Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbaGNUk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbaGNUkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:40:24 -0400
Message-ID: <1405370408.25580.13.camel@deneb.redhat.com>
Subject: Re: [PATCH 16/38] c6x: clean-up uapi Kbuild file
From: Mark Salter <msalter@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Date: Mon, 14 Jul 2014 16:40:08 -0400
In-Reply-To: <1405350546-28467-16-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
	 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
	 <1405350546-28467-16-git-send-email-sam@ravnborg.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 17:08 +0200, Sam Ravnborg wrote:
> Remove redundant assignments.
> Also drop kvm_para.h wrapper as it is never referenced from c6x code.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> ---

Acked-by: Mark Salter <msalter@redhat.com>

>  arch/c6x/include/uapi/asm/Kbuild | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/c6x/include/uapi/asm/Kbuild b/arch/c6x/include/uapi/asm/Kbuild
> index e9bc2b2..b15bf6b 100644
> --- a/arch/c6x/include/uapi/asm/Kbuild
> +++ b/arch/c6x/include/uapi/asm/Kbuild
> @@ -1,12 +1,2 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
> -
> -generic-y += kvm_para.h
> -
> -header-y += byteorder.h
> -header-y += kvm_para.h
> -header-y += ptrace.h
> -header-y += setup.h
> -header-y += sigcontext.h
> -header-y += swab.h
> -header-y += unistd.h


