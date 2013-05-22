Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3EVXsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:48:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:35143 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab3EVXsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:48:22 -0400
Date: Thu, 23 May 2013 09:55:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mhcerri@linux.vnet.ibm.com,
        fin@linux.vnet.ibm.com
Subject: Re: [PATCHv2] maintainers: remove Kent from maintainers list
In-Reply-To: <20130522192306.GA29733@ennui.austin.ibm.com>
Message-ID: <alpine.LRH.2.02.1305230955290.11805@tundra.namei.org>
References: <20130522192306.GA29733@ennui.austin.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Kent Yoder wrote:

> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> ---
> v2: Replace Kent with other so that NX isn't unmaintained,
>     leave tpmdd-devel as maintainer for TPM
> 
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I already applied your first patch.

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 829c032..5ec293d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3971,7 +3971,8 @@ S:	Maintained
>  F:	arch/ia64/
>  
>  IBM Power in-Nest Crypto Acceleration
> -M:	Kent Yoder <key@linux.vnet.ibm.com>
> +M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> +M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Supported
>  F:	drivers/crypto/nx/
> @@ -8212,7 +8213,6 @@ S:	Odd fixes
>  F:	drivers/media/usb/tm6000/
>  
>  TPM DEVICE DRIVER
> -M:	Kent Yoder <key@linux.vnet.ibm.com>
>  M:	Rajiv Andrade <mail@srajiv.net>
>  W:	http://tpmdd.sourceforge.net
>  M:	Marcel Selhorst <tpmdd@selhorst.net>
> -- 
> 1.7.11.7
> 

-- 
James Morris
<jmorris@namei.org>
