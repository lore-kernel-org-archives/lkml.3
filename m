Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaLPQo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:44:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49685 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaLPQo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:44:58 -0500
Date: Tue, 16 Dec 2014 08:44:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] drivers: watchdog: Fixed missing blank line warning
Message-ID: <20141216164444.GC26966@roeck-us.net>
References: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010203.54906189.0852,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 09:55:22PM +0530, Athira Lekshmi wrote:
> Added a new line after declarations to remove the warning:

'Add', per SubmittingPatches, Chapter 2.

You might also want to add that this is a checkpatch warning
(not a compiler warning).

> 'Missing blank line after declarations'
> 

"drivers" in the subject line of your patches is irrelevant. 
On the other side, the actual drivers you are touching are missing,
resulting in eight identical subject lines. That is not really helpful.

Use something like "watchdog: wdt_pci: ..." to give the maintainer
a hint about the modified driver.

Guenter

> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/watchdog/wdt_pci.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
> index 48b2c05..b84a180 100644
> --- a/drivers/watchdog/wdt_pci.c
> +++ b/drivers/watchdog/wdt_pci.c
> @@ -279,6 +279,7 @@ static int wdtpci_get_temperature(int *temperature)
>  {
>  	unsigned short c;
>  	unsigned long flags;
> +
>  	spin_lock_irqsave(&wdtpci_lock, flags);
>  	c = inb(WDT_RT);
>  	udelay(8);
> @@ -366,6 +367,7 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
>  
>  			for (i = 0; i != count; i++) {
>  				char c;
> +
>  				if (get_user(c, buf + i))
>  					return -EFAULT;
>  				if (c == 'V')
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
