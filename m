Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaAFKFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:05:54 -0500
Received: from multi.imgtec.com ([194.200.65.239]:17363 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaAFKFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:05:53 -0500
Message-ID: <52CA7FFE.9070405@imgtec.com>
Date: Mon, 6 Jan 2014 10:05:50 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-metag@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Geert Uytterhoeven" <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] metag/smp: Make boot_secondary() static
References: <1388763831-27357-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1388763831-27357-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_06_10_05_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 15:43, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> boot_secondary() is not used outside arch/metag/kernel/smp.c, hence make it
> static.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Thanks, applied.

Cheers
James

> ---
>  arch/metag/kernel/smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
> index 7c0113142981..fc4b80e1e06a 100644
> --- a/arch/metag/kernel/smp.c
> +++ b/arch/metag/kernel/smp.c
> @@ -68,7 +68,7 @@ static DECLARE_COMPLETION(cpu_running);
>  /*
>   * "thread" is assumed to be a valid Meta hardware thread ID.
>   */
> -int boot_secondary(unsigned int thread, struct task_struct *idle)
> +static int boot_secondary(unsigned int thread, struct task_struct *idle)
>  {
>  	u32 val;
>  
> 

