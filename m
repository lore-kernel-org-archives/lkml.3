Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaFDOGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:06:39 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:45813 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaFDOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:06:37 -0400
Subject: Re: [PATCH 4/4] GenWQE: Increase driver version number
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
In-Reply-To: <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
	 <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 04 Jun 2014 16:06:32 +0200
Message-ID: <1401890792.24099.11.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060414-4966-0000-0000-00000041FFFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 04.06.2014, 10:57 -0300 schrieb Kleber Sacilotto de
Souza:
> Increase genwqe driver version number.
> 
> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> ---
>  drivers/misc/genwqe/genwqe_driver.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
> index cd52631..a506e9a 100644
> --- a/drivers/misc/genwqe/genwqe_driver.h
> +++ b/drivers/misc/genwqe/genwqe_driver.h
> @@ -36,7 +36,7 @@
>  #include <asm/byteorder.h>
>  #include <linux/genwqe/genwqe_card.h>
> 
> -#define DRV_VERS_STRING		"2.0.15"
> +#define DRV_VERS_STRING		"2.0.21"
> 
>  /*
>   * Static minor number assignement, until we decide/implement

Thanks for contributing those additions to our driver.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

