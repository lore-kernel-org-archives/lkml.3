Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaFRXNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:13:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFRXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:13:43 -0400
Date: Wed, 18 Jun 2014 16:17:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: Re: [PATCH] MAINTAINERS: add entry for VMware Balloon driver
Message-ID: <20140618231742.GB7234@kroah.com>
References: <1403132941-1394-1-git-send-email-dtor@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403132941-1394-1-git-send-email-dtor@vmware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:09:01PM -0700, Dmitry Torokhov wrote:
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> ---
>  MAINTAINERS                |    6 ++++++
>  drivers/misc/vmw_balloon.c |    2 +-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6c484ac..3a446e8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9645,6 +9645,12 @@ L:	virtualization@lists.linux-foundation.org
>  S:	Supported
>  F:	arch/x86/kernel/cpu/vmware.c
>  
> +VMWARE BALLOON DRIVER
> +M:	"VMware, Inc." <pv-drivers@vmware.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/misc/vmw_balloon.c

I really hate having a "alias" as a maintainer, and not a "real" name.
Kernel development is done by individuals, we don't have companies as
authors or signed-off-by lines, we have developers.

So I will not accept this, sorry.  Please find a real person who is
willing to maintain this code, or just mark it unsupported.

thanks,

greg k-h
