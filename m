Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3GJHZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:25:07 -0400
Received: from ozlabs.org ([203.10.76.45]:52254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab3GJHZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:25:06 -0400
From: Michael Neuling <mikey@neuling.org>
To: Bharat Bhushan <r65777@freescale.com>
cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com, agraf@suse.de,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: Re: [PATCH 1/2] powerpc: remove unnecessary line continuations
In-reply-to: <1372918546-15075-2-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com> <1372918546-15075-2-git-send-email-Bharat.Bhushan@freescale.com>
Comments: In-reply-to Bharat Bhushan <r65777@freescale.com>
   message dated "Thu, 04 Jul 2013 11:45:45 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 10 Jul 2013 17:25:01 +1000
Message-ID: <21869.1373441101@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharat Bhushan <r65777@freescale.com> wrote:

> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>

Acked-by: Michael Neuling <mikey@neuling.org>


> ---
>  arch/powerpc/kernel/process.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index c517dbe..19b8733 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -325,7 +325,7 @@ static void set_debug_reg_defaults(struct thread_struct *thread)
>  	/*
>  	 * Force User/Supervisor bits to b11 (user-only MSR[PR]=1)
>  	 */
> -	thread->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |	\
> +	thread->dbcr1 = DBCR1_IAC1US | DBCR1_IAC2US |
>  			DBCR1_IAC3US | DBCR1_IAC4US;
>  	/*
>  	 * Force Data Address Compare User/Supervisor bits to be User-only
> -- 
> 1.7.0.4
> 
> 
