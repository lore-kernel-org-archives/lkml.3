Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3GVRdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:33:37 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29906 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3GVRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:33:35 -0400
Date: Mon, 22 Jul 2013 19:33:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH] staging/lustre: fix Kconfig bool defaults
Message-ID: <20130722173332.GA14140@merkur.ravnborg.org>
References: <1374511290-4883-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374511290-4883-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:41:30AM +0800, Peng Tao wrote:
> Should be y/n instead of true/false...
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>

default n is the default.
So usually we advice to drop this.

	Sam


> ---
> This applis on top of the 48 Intel tree ported patches.
> 
>  drivers/staging/lustre/lustre/Kconfig |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 566d89d..d80a78f 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -50,7 +50,7 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
>  config LUSTRE_DEBUG_LU_REF_CHECK
>  	bool "Enable Lustre DEBUG object refcount checks"
>  	depends on LUSTRE_FS
> -	default false
> +	default n
>  	help
>  	  This option is mainly for debug purpose. It enables Lustre code to track
>  	  references between objects.
> @@ -60,7 +60,7 @@ config LUSTRE_DEBUG_LU_REF_CHECK
>  config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  	bool "Enable Lustre DEBUG checks"
>  	depends on LUSTRE_FS
> -	default false
> +	default n
>  	help
>  	  This option is mainly for debug purpose. It enables Lustre code to do
>  	  expensive checks that may have a performance impact.
> @@ -70,4 +70,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  config LUSTRE_TRANSLATE_ERRNOS
>  	bool
>  	depends on LUSTRE_FS && !X86
> -	default true
> +	default y
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
