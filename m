Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab3EBSIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:08:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42771 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783Ab3EBSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:08:22 -0400
Date: Thu, 2 May 2013 19:08:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] Remove trailing whitespace in arch/arm/Makefile
Message-ID: <20130502180814.GA14496@n2100.arm.linux.org.uk>
References: <5B221EAE-1E99-4E15-9696-389B32057464@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B221EAE-1E99-4E15-9696-389B32057464@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way to get patches in via me is via the patch system.  I totally
struggle to keep up with emails on these lists now.

On Thu, May 02, 2013 at 06:49:14PM +1000, Daniel Tang wrote:
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  arch/arm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index ee4605f..479b209 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -313,7 +313,7 @@ define archhelp
>    echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
>    echo  '* xipImage      - XIP kernel image, if configured (arch/$(ARCH)/boot/xipImage)'
>    echo  '  uImage        - U-Boot wrapped zImage'
> -  echo  '  bootpImage    - Combined zImage and initial RAM disk' 
> +  echo  '  bootpImage    - Combined zImage and initial RAM disk'
>    echo  '                  (supply initrd image via make variable INITRD=<path>)'
>    echo  '* dtbs          - Build device tree blobs for enabled boards'
>    echo  '  install       - Install uncompressed kernel'
> -- 
> 1.8.1.3
