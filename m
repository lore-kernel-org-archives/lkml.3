Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbaGRUuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:50:06 -0400
Received: from mout.gmx.net ([212.227.15.19]:61410 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaGRUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:50:04 -0400
Message-ID: <53C98860.2010905@gmx.de>
Date: Fri, 18 Jul 2014 22:49:36 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, jejb@parisc-linux.org
CC: tiwai@suse.de, jkosina@suse.cz, joe@perches.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: Remove FIXME comment
References: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:UwU6FfE67AdI4DuzEFswkEeuek/ti09McvJ9sLR93KbcFERkIk1
 ZnhrOMS4vlxXNT7ehxgGb6sFU3T/1rmbCAN9ReoiwC1bp9EM1puixXW+07Kx2cpDzMcaDwb
 R/VTmD7aX9x1K7cEScwZxfrVxdLPeoBMxBTjfYtLY4ZjIOh5ugSOqYx9rffpQlQPsaK/N3P
 poZxO2gZ+nb3MTpwXcBug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 10:37 PM, Nicholas Krause wrote:
> The comment for size of frame not being needed is incorrect , the
> function called needs this parameter.

Thanks for the patch Nicholas.

It has been queued up:
https://patchwork.kernel.org/patch/4587631/
and
https://patchwork.kernel.org/patch/4486231/

I will apply it at some point, but not yet.
There are other (more important) patches upcoming regarding the 
signal handling,  and I don't want to break those at the moment.

Helge

> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/parisc/kernel/signal.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
> index 1cba8f2..1d550b5 100644
> --- a/arch/parisc/kernel/signal.c
> +++ b/arch/parisc/kernel/signal.c
> @@ -240,7 +240,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  #endif
>  	
>  	usp = (regs->gr[30] & ~(0x01UL));
> -	/*FIXME: frame_size parameter is unused, remove it. */
>  	frame = get_sigframe(ka, usp, sizeof(*frame));
>  
>  	DBG(1,"SETUP_RT_FRAME: START\n");
> 

