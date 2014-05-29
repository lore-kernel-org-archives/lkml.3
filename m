Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaE2NVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:21:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30969 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaE2NVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:21:06 -0400
Date: Thu, 29 May 2014 16:20:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-sh@vger.kernel.org, gregkh@linuxfoundation.org,
        horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
Message-ID: <20140529132034.GB15585@mwanda>
References: <20140529131650.2329.3197.sendpatchset@w520>
 <20140529131732.2329.50630.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529131732.2329.50630.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:17:32PM +0900, Magnus Damm wrote:
> --- /dev/null
> +++ work/drivers/staging/board/Kconfig	2014-05-29 21:40:41.000000000 +0900
> @@ -0,0 +1,7 @@
> +config STAGING_BOARD
> +	boolean "Staging Board Support"
> +	help
> +	  Select to enable per-board staging support code.
> +
> +	  If in doubt, say N here.
> +

Actually, you're probably going to need to add a bunch of dependencies
here or it will break "make randconfig" right away.  Sorry that I forgot
about this in the first review.

regards,
dan carpenter

