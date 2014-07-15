Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbaGOJFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:05:03 -0400
Received: from sym2.noone.org ([178.63.92.236]:54577 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709AbaGOJFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:05:00 -0400
Date: Tue, 15 Jul 2014 11:04:57 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 26/29] Add ELF machine define for Nios2
Message-ID: <20140715090456.GD7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-27-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405413956-2772-27-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 at 10:45:53 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

This should probably be sent/applied before "[PATCH v2 14/29] nios2: ELF
definitions", since there EM_ALTERA_NIOS2 is already used.

> ---
>  include/uapi/linux/elf-em.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
> index 01529bd..7f06c0d 100644
> --- a/include/uapi/linux/elf-em.h
> +++ b/include/uapi/linux/elf-em.h
> @@ -33,6 +33,7 @@
>  #define EM_M32R		88	/* Renesas M32R */
>  #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
>  #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
> +#define EM_ALTERA_NIOS2	113	/* Altera Nios II soft-core processor */
>  #define EM_TI_C6000	140	/* TI C6X DSPs */
>  #define EM_AARCH64	183	/* ARM 64 bit */
>  #define EM_FRV		0x5441	/* Fujitsu FR-V */
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
