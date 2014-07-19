Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaGSMF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 08:05:59 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61922 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbaGSMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 08:05:58 -0400
Message-ID: <1405771556.18077.5.camel@x220>
Subject: Re: [PATCH] mips: Remove uneeded line in cmp_smp_finish
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: ralf@linux-mips.org, paul.burton@imgtec.com, Leonid.Yegoshin@imgtec.com,
        markos.chandras@imgtec.com, Steven.Hill@imgtec.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2014 14:05:56 +0200
In-Reply-To: <1405746604-7737-1-git-send-email-xerofoify@gmail.com>
References: <1405746604-7737-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2014 12:05:56.0659 (UTC) FILETIME=[CBF1B830:01CFA349]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-19 at 01:10 -0400, Nicholas Krause wrote:
> This patch removes a unneeded line from this file as stated by the
> fix me in this file.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/mips/kernel/smp-cmp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
> index fc8a515..61bfa20 100644
> --- a/arch/mips/kernel/smp-cmp.c
> +++ b/arch/mips/kernel/smp-cmp.c
> @@ -60,8 +60,6 @@ static void cmp_smp_finish(void)
>  {
>  	pr_debug("SMPCMP: CPU%d: %s\n", smp_processor_id(), __func__);
>  
> -	/* CDFIXME: remove this? */
> -	write_c0_compare(read_c0_count() + (8 * mips_hpt_frequency / HZ));

That comment ends in a question mark. I wonder why...
 
>  #ifdef CONFIG_MIPS_MT_FPAFF
>  	/* If we have an FPU, enroll ourselves in the FPU-full mask */


Paul Bolle

