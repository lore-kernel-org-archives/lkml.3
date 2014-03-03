Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaCCGQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:16:20 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36845 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaCCGQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:16:17 -0500
MIME-Version: 1.0
In-Reply-To: <1391441617-21518-1-git-send-email-james.hogan@imgtec.com>
References: <1391441617-21518-1-git-send-email-james.hogan@imgtec.com>
Date: Mon, 3 Mar 2014 14:16:16 +0800
Message-ID: <CAF0htA7-MXC=4WyZK+jTLXgrKjnoTEdCkjRyhSsJsvuXNJAmUQ@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: add sched_setattr/sched_getattr syscalls
From: Lennox Wu <lennox.wu@gmail.com>
To: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Acked-by: Lennox Wu<lennox.wu@gmail.com>

2014-02-03 23:33 GMT+08:00 James Hogan <james.hogan@imgtec.com>:
> Add the sched_setattr and sched_getattr syscalls to the generic syscall
> list, which is used by the following architectures: arc, arm64, c6x,
> hexagon, metag, openrisc, score, tile, unicore32.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Cc: linux-metag@vger.kernel.org
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Chen Liqin <liqin.linux@gmail.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  include/uapi/asm-generic/unistd.h | 6 +++++->  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index a20a9b4d3871..dde8041f40d2 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -692,9 +692,13 @@ __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
>  __SYSCALL(__NR_kcmp, sys_kcmp)
>  #define __NR_finit_module 273
>  __SYSCALL(__NR_finit_module, sys_finit_module)
> +#define __NR_sched_setattr 274
> +__SYSCALL(__NR_sched_setattr, sys_sched_setattr)
> +#define __NR_sched_getattr 275
> +__SYSCALL(__NR_sched_getattr, sys_sched_getattr)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 274
> +#define __NR_syscalls 276
>
>  /*
>   * All syscalls below here should go away really,
> --
> 1.8.1.2
>
>
