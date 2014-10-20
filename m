Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaJTS2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:28:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:55088 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJTS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:28:07 -0400
Date: Mon, 20 Oct 2014 20:28:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Shao <huishao@microsoft.com>
cc: gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
In-Reply-To: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
Message-ID: <alpine.DEB.2.11.1410202027220.5308@nanos>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Thomas Shao wrote:

And again you forgot to cc John Stultz on this....

> Export do_adjtimex function for hyper-v Time Synchronization component
> 
> Signed-off-by: Thomas Shao <huishao@microsoft.com>
> ---
>  kernel/time/timekeeping.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index ec1791f..205a4b3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(do_adjtimex);
>  
>  #ifdef CONFIG_NTP_PPS
>  /**
> -- 
> 1.7.1
> 
> 
