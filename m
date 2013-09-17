Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3IQHAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:00:36 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56060 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3IQHAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:00:34 -0400
MIME-Version: 1.0
X-Originating-IP: [81.241.63.71]
In-Reply-To: <1379370502-30376-3-git-send-email-khilman@linaro.org>
References: <1379370502-30376-1-git-send-email-khilman@linaro.org>
	<1379370502-30376-3-git-send-email-khilman@linaro.org>
Date: Tue, 17 Sep 2013 09:00:34 +0200
Message-ID: <CAORVsuUrwH+4csjT_rpk2e7z7gje1ksrVdeTDYVAZ7bRZbd5UQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] nohz_full: Kconfig: drop requrement on 64-bit
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

FWIW typo in the title: 'requirement'.

Regards,
Jean

On Tue, Sep 17, 2013 at 12:28 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Now that VIRT_CPU_ACCOUNTING_GEN no longer has a 64-bit requirement,
> it can be dropped here as well.
>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/time/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 2b62fe8..a54e3e9 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -99,8 +99,6 @@ config NO_HZ_FULL
>         depends on SMP
>         # RCU_USER_QS dependency
>         depends on HAVE_CONTEXT_TRACKING
> -       # VIRT_CPU_ACCOUNTING_GEN dependency
> -       depends on 64BIT
>         select NO_HZ_COMMON
>         select RCU_USER_QS
>         select RCU_NOCB_CPU
> --
> 1.8.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
