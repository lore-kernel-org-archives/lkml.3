Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaFTA15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:27:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52351 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbaFTA14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:27:56 -0400
X-Sasl-enc: 3VLWEZVEFyydmZR6WmgDzDCbkCH0N/5OjrqgsDhbiKbX 1403224075
Date: Thu, 19 Jun 2014 17:31:55 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: pramod.gurav.etc@gmail.com
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Subject: Re: [PATCH v2 2/2] staging: alarm-dev: Support to Compile as Module
Message-ID: <20140620003155.GA4647@kroah.com>
References: <1402640383-13324-1-git-send-email-pramod.gurav.etc@gmail.com>
 <1402640383-13324-2-git-send-email-pramod.gurav.etc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402640383-13324-2-git-send-email-pramod.gurav.etc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:49:43AM +0530, pramod.gurav.etc@gmail.com wrote:
> From: Pramod Gurav <pramod.gurav.etc@gmail.com>
> 
> Currently this alarm-dev can be compiles only as built in
> driver. This adds support to compile it as module as well which is in
> planned activity (See drivers/staging/android/TODO)
> 
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

With this change you will get a warning about a missing
MODULE_LICENSE(), can you please send a follow-on patch to fix that?

thanks,

greg k-h
