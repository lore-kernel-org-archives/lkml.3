Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaJPIRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:17:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60766 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164AbaJPIRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:17:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: akpm@linux-foundation.org, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishu13285@gmail.com
Subject: Re: [PATCH] [kernel]: process: replace printk with pr_err
Date: Thu, 16 Oct 2014 10:37:50 +0200
Message-ID: <2484936.7PAAKpDVM2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413435995-32317-1-git-send-email-vishnu.ps@samsung.com>
References: <1413435995-32317-1-git-send-email-vishnu.ps@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 16, 2014 10:36:35 AM Vishnu Pratap Singh wrote:
> This patch replaces printk(KERN_ERR...) with pr_err found.

What is the reason?  Does the existing code cause any problems to happen?

> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
> ---
>  kernel/power/process.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 7b32322..401f7ee 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -85,7 +85,7 @@ static int try_to_freeze_tasks(bool user_only)
>  
>  	if (todo) {
>  		printk("\n");
> -		printk(KERN_ERR "Freezing of tasks %s after %d.%03d seconds "
> +		pr_err("Freezing of tasks %s after %d.%03d seconds "
>  		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
>  		       wakeup ? "aborted" : "failed",
>  		       elapsed_msecs / 1000, elapsed_msecs % 1000,
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
