Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbbA2BbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:31:09 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:38532 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbA2BbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:31:07 -0500
Date: Wed, 28 Jan 2015 23:09:17 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: James Hogan <james.hogan@imgtec.com>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MIPS: Add arch CDMM definitions and probing
In-Reply-To: <1422393401-13543-2-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.LFD.2.11.1501280253280.28301@eddie.linux-mips.org>
References: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com> <1422393401-13543-2-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, James Hogan wrote:

> diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
> index 33866fce4d63..2086372fa72a 100644
> --- a/arch/mips/include/asm/cpu.h
> +++ b/arch/mips/include/asm/cpu.h
> @@ -370,6 +370,7 @@ enum cpu_type_enum {
>  #define MIPS_CPU_RIXIEX		0x200000000ull /* CPU has unique exception codes for {Read, Execute}-Inhibit exceptions */
>  #define MIPS_CPU_MAAR		0x400000000ull /* MAAR(I) registers are present */
>  #define MIPS_CPU_FRE		0x800000000ull /* FRE & UFE bits implemented */
> +#define MIPS_CPU_CDMM		0x10000000000ll /* CPU has Common Device Memory Map */

 Is it a typo here: 0x10000000000ll vs 0x1000000000ull?

  Maciej
