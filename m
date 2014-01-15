Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaAOFuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:50:46 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33189 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaAOFuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:50:44 -0500
Message-ID: <52D62080.4080303@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 11:15:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Documentation / CPU hotplug: Fix the typo in example
 code
References: <1389762626-28982-1-git-send-email-sangjung.woo@samsung.com>
In-Reply-To: <1389762626-28982-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011505-6102-0000-0000-000004C991DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 10:40 AM, Sangjung Woo wrote:
> As the notifier_block name (i.e. foobar_cpu_notifer) is different from
> the parameter (i.e.foobar_cpu_notifier) of register function, that is
> definitely error and it also makes readers confused.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  Documentation/cpu-hotplug.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
> index 8cb9938..be675d2 100644
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -285,7 +285,7 @@ A: This is what you would need in your kernel code to receive notifications.
>  		return NOTIFY_OK;
>  	}
> 
> -	static struct notifier_block foobar_cpu_notifer =
> +	static struct notifier_block foobar_cpu_notifier =
>  	{
>  	   .notifier_call = foobar_cpu_callback,
>  	};
> 

