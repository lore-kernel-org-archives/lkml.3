Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaBIT65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:58:57 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54724 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbaBIT64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:58:56 -0500
Message-ID: <1391975934.25855.14.camel@x220>
Subject: Re: [PATCH 02/28] Remove OF_I2C
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "open list:I2C SUBSYSTEM" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 20:58:54 +0100
In-Reply-To: <1391971686-9517-3-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 19:58:54.0653 (UTC) FILETIME=[5C73F6D0:01CF25D1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/i2c/busses/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index f5ed031..de17c55 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -387,7 +387,7 @@ config I2C_CBUS_GPIO
>  
>  config I2C_CPM
>  	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
> -	depends on (CPM1 || CPM2) && OF_I2C
> +	depends on CPM1 || CPM2
>  	help
>  	  This supports the use of the I2C interface on Freescale
>  	  processors with CPM1 or CPM2.

This needs testing. Since when is OF_I2C orphaned? Ie, when was the last
time it was possible to set I2C_CPM?


Paul Bolle

