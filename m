Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaFLQvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:51:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47689 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbaFLQvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:51:41 -0400
X-Sasl-enc: B3Wsfig756h14lOlof59zDxqoZFUCk73a2Szvm//8tpH 1402591899
Date: Thu, 12 Jun 2014 09:55:30 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: pramod.gurav.etc@gmail.com
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] staging: alarm-dev: Support to Compile as Module
Message-ID: <20140612165530.GA14019@kroah.com>
References: <1402569495-11308-1-git-send-email-pramod.gurav.etc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402569495-11308-1-git-send-email-pramod.gurav.etc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:08:15PM +0530, pramod.gurav.etc@gmail.com wrote:
> From: Pramod Gurav <pramod.gurav.etc@gmail.com>
> 
> Currently this alarm-dev can be compiles only as built in
> driver. This adds support to compile it as module as well.
> This has dependancy on:
> https://lkml.org/lkml/2014/6/12/180
> 
> which exports symbol of alarmtimer function.
> 
> CC: Greg Kroah-Hartman <greg@kroah.com>
> CC: Brian Swetland <swetland@google.com>
> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
> ---
>  drivers/staging/android/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> index 99e484f..c359317 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -76,7 +76,7 @@ config ANDROID_LOW_MEMORY_KILLER
>  	  Registers processes to be killed when memory is low
>  
>  config ANDROID_INTF_ALARM_DEV
> -	bool "Android alarm driver"
> +	tristate "Android alarm driver"
>  	depends on RTC_CLASS
>  	default n
>  	---help---

Please resend the first patch (it's not a "trivial one") as part of this
patch series.

And do you ever really want this code as a module?  What will auto-load
it if needed?

thanks,

greg k-h
