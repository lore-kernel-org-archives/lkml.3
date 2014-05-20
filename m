Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaETB3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:29:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaETB3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:29:50 -0400
Date: Tue, 20 May 2014 10:29:46 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shigekatsu.tateno@atmel.com
Subject: Re: [PATCH] staging: ozwpan: Change Maintainer
Message-ID: <20140520012946.GA12333@kroah.com>
References: <1400509050-6300-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400509050-6300-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:17:30PM +0100, Rupesh Gujare wrote:
> I will be not able to work on ozwpan driver anymore.
> Remove my name & add Tateno as maintainer.
> 
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  MAINTAINERS                 |    2 +-
>  drivers/staging/ozwpan/TODO |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0de64a5..3a9e4d83 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8466,7 +8466,7 @@ S:	Maintained
>  F:	drivers/staging/olpc_dcon/
>  
>  STAGING - OZMO DEVICES USB OVER WIFI DRIVER
> -M:	Rupesh Gujare <rupesh.gujare@atmel.com>
> +M:	Shigekatsu Tateno <shigekatsu.tateno@atmel.com>

Can I get an "ack" from Shigekatsu?  I don't like adding someone as a
maintainer if they don't know about it...

thanks,

greg k-h
