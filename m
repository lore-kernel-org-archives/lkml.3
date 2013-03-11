Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3CKRRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:17:31 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:54415 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CKRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:17:29 -0400
Date: Mon, 11 Mar 2013 10:17:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michail Kurachkin <michail.kurachkin@promwad.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>, Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH v2 01/11] staging: Initial commit of TDM core
Message-ID: <20130311171726.GA25166@kroah.com>
References: <cover.1362133319.git.michail.kurachkin@promwad.com>
 <563f0589ba8c56bd194938f8bff80a06b15f9418.1362133319.git.michail.kurachkin@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <563f0589ba8c56bd194938f8bff80a06b15f9418.1362133319.git.michail.kurachkin@promwad.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 01:50:37PM +0300, Michail Kurachkin wrote:
> From: Michail Kurochkin <michail.kurachkin@promwad.com>
> 
> Signed-off-by: Michail Kurochkin <michail.kurachkin@promwad.com>
> ---
>  drivers/staging/Kconfig        |    4 +
>  drivers/staging/Makefile       |    4 +-
>  drivers/staging/tdm/Kconfig    |   38 ++
>  drivers/staging/tdm/Makefile   |   19 +
>  drivers/staging/tdm/tdm.h      |  292 ++++++++++++++
>  drivers/staging/tdm/tdm_core.c |  826 ++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1182 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/staging/tdm/Kconfig
>  create mode 100644 drivers/staging/tdm/Makefile
>  create mode 100644 drivers/staging/tdm/tdm.h
>  create mode 100644 drivers/staging/tdm/tdm_core.c
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 329bdb4..9bba991 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -26,6 +26,10 @@ if STAGING
>  
>  source "drivers/staging/et131x/Kconfig"
>  
> +source "drivers/staging/si3226x/Kconfig"
> +
> +source "drivers/staging/tdm/Kconfig"

You just broke the build with this patch :(

Please, EVERY patch has to be buildable at every step of the way.  I
can't take patches that break the build, especially ones that do so in
such obvious ways.

Please resend this whole series, fixing this problem, and changing the
 Subject: lines like I asked for last time as well.

thanks,

greg k-h
