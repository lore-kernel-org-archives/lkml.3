Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3GXTfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:35:23 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39305 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3GXTfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:35:21 -0400
Date: Wed, 24 Jul 2013 21:35:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: mail-agent-noreply@emc.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH 6/8] staging/lustre: fix Kconfig bool defaults
Message-ID: <20130724193519.GA16434@merkur.ravnborg.org>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com> <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:31:30PM +0800, mail-agent-noreply@emc.com wrote:
> From: Peng Tao <bergwolf@gmail.com>
> 
> Should be y instead of true.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> ---
>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 9ae7fa8..e3b3c74 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -52,4 +52,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  config LUSTRE_TRANSLATE_ERRNOS
>  	bool
>  	depends on LUSTRE_FS && !X86
> -	default true
> +	default y

This was the file that contained some buggy "default false" IIRC.
Please delete these.

	Sam
