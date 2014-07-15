Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaGOKO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:14:29 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:46329 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbaGOKOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:14:25 -0400
Message-ID: <53C4FEFD.20104@imgtec.com>
Date: Tue, 15 Jul 2014 11:14:21 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 13/38] arm64: clean-up uapi Kbuild file
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-13-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-13-git-send-email-sam@ravnborg.org>
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
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/uapi/asm/Kbuild | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
> index 942376d..aa17aa8 100644
> --- a/arch/arm64/include/uapi/asm/Kbuild
> +++ b/arch/arm64/include/uapi/asm/Kbuild
> @@ -1,21 +1,5 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -generic-y += kvm_para.h

Don't you need this in order for it to be picked up by patch 9 and
exported? I guess the non-uapi generic-y += kvm_para.h might be
redundant though.

Cheers
James

> -
> -header-y += auxvec.h
> -header-y += bitsperlong.h
> -header-y += byteorder.h
> -header-y += fcntl.h
>  header-y += hwcap.h
> -header-y += kvm_para.h
>  header-y += perf_regs.h
> -header-y += param.h
> -header-y += ptrace.h
> -header-y += setup.h
> -header-y += sigcontext.h
> -header-y += siginfo.h
> -header-y += signal.h
> -header-y += stat.h
> -header-y += statfs.h
> -header-y += unistd.h
> 
