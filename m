Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaCYGxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 02:53:17 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:35506 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbaCYGxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 02:53:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.11
Date: Tue, 25 Mar 2014 14:53:05 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Message-ID: <14860329.28442.1395730385637.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53302AF3.4000700@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/unico?=
 =?utf-8?Q?re32/include/asm/ptrac?=
 =?utf-8?Q?e.h:_add_generic_definition_for_profile=5Fpc()?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Add generic definition just like another architectures have done, or
> can not pass compiling with allmodconfig, the related error:
> 
>     CC      kernel/profile.o
>   kernel/profile.c: In function ‘profile_tick’:
>   kernel/profile.c:419: error: implicit declaration of function ‘profile_pc’
>   make[1]: *** [kernel/profile.o] Error 1
>   make: *** [kernel] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/include/asm/ptrace.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/unicore32/include/asm/ptrace.h b/arch/unicore32/include/asm/ptrace.h
> index 9df53d9..02bf5a4 100644
> --- a/arch/unicore32/include/asm/ptrace.h
> +++ b/arch/unicore32/include/asm/ptrace.h
> @@ -55,6 +55,7 @@ static inline int valid_user_regs(struct pt_regs *regs)
>  
>  #define instruction_pointer(regs)	((regs)->UCreg_pc)
>  #define user_stack_pointer(regs)	((regs)->UCreg_sp)
> +#define profile_pc(regs)		instruction_pointer(regs)
>  
>  #endif /* __ASSEMBLY__ */
>  #endif
> -- 
> 1.7.9.5

