Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaJGFXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:23:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:35582 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaJGFXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:23:02 -0400
Message-ID: <1412659363.30859.146.camel@pasglop>
Subject: Re: [PATCH v2 2/5] powerpc: Adding macro for accessing Thread
 Switch Control Register
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 07 Oct 2014 16:22:43 +1100
In-Reply-To: <1412149617-3178-3-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1412149617-3178-3-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fold that one in the patch that uses that register

On Wed, 2014-10-01 at 13:16 +0530, Shreyas B. Prabhu wrote:
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 0c05059..cb65a73 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -371,6 +371,7 @@
>  #define SPRN_DBAT7L	0x23F	/* Data BAT 7 Lower Register */
>  #define SPRN_DBAT7U	0x23E	/* Data BAT 7 Upper Register */
>  #define SPRN_PPR	0x380	/* SMT Thread status Register */
> +#define SPRN_TSCR	0x399	/* Thread Switch Control Register */
>  
>  #define SPRN_DEC	0x016		/* Decrement Register */
>  #define SPRN_DER	0x095		/* Debug Enable Regsiter */


