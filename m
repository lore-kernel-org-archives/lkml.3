Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaJVFfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:35:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaJVFfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:35:00 -0400
Date: Tue, 21 Oct 2014 22:34:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update help of CONFIG_MTD_OF_PARTS
Message-ID: <20141022053453.GA16128@brian-ubuntu>
References: <1412946377-18933-1-git-send-email-sojkam1@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412946377-18933-1-git-send-email-sojkam1@fel.cvut.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 03:06:17PM +0200, Michal Sojka wrote:
> The help text of CONFIG_MTD_OF_PARTS refers to additional documentation
> in booting-without-of.txt but this documentation was moved to another
> file in commit efcc2da3fd148c9acb7d7cf1d9800e0649f950fc (Stefan Roese:
> Factor MTD physmap bindings out of booting-without-of). This updates the
> help text to point to the right place.
> 
> Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
> ---
>  drivers/mtd/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 94b8210..fa8371a 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -133,7 +133,7 @@ config MTD_OF_PARTS
>  	help
>  	  This provides a partition parsing function which derives
>  	  the partition map from the children of the flash node,
> -	  as described in Documentation/devicetree/booting-without-of.txt.
> +	  as described in Documentation/devicetree/bindings/mtd/mtd-physmap.txt.

Did you read this file before sending the patch? I'm pretty sure you're
looking for this file instead:

  Documentation/devicetree/bindings/mtd/partition.txt

>  
>  config MTD_AR7_PARTS
>  	tristate "TI AR7 partitioning support"

Brian
