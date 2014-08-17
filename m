Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaHQQiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:38:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaHQQiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:38:15 -0400
Date: Sun, 17 Aug 2014 09:37:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 09/10] lustre: Add MAINTAINERS entry
Message-ID: <20140817163739.GA15982@kroah.com>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
 <1408121295-29115-10-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408121295-29115-10-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:48:14PM -0400, Oleg Drokin wrote:
> Just add the entry with some info.
> 
> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e2eb4c..369183b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8646,6 +8646,14 @@ W:	http://www.lirc.org/
>  S:	Odd Fixes
>  F:	drivers/staging/media/lirc/
>  
> +STAGING - LUSTRE PARALLEL FILESYSTEM
> +M:	Oleg Drokin <oleg.drokin@intel.com>
> +M:	Andreas Dilger <andreas.dilger@intel.com>
> +L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)

I _really_ hate moderated mailing lists for kernel development stuff.
Why not just use the driverdev mailing list instead?

I note that you didn't even cc: this patch series to that list...

thanks,

greg k-h
