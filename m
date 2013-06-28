Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3F1CgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:36:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51194 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab3F1Cf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:35:58 -0400
X-Spam-Score: -100.9
Message-ID: <51CCF659.7070908@asianux.com>
Date: Fri, 28 Jun 2013 10:35:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "'Jiri Kosina'" <trivial@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/iomap.h: trivial: use '__GENERIC_IOMAP_H'
 instead of '__GENERIC_IO_H'
References: <51CCF58E.9000007@asianux.com>
In-Reply-To: <51CCF58E.9000007@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oh, sorry, need use '__ASM_GENERIC_IOMAP_H, instead.

I will send patch v2.


On 06/28/2013 10:31 AM, Chen Gang wrote:
> Recommend to let the header file macro mark match the file name.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/asm-generic/iomap.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index 6afd7d6..236c78c 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -1,5 +1,5 @@
> -#ifndef __GENERIC_IO_H
> -#define __GENERIC_IO_H
> +#ifndef __GENERIC_IOMAP_H
> +#define __GENERIC_IOMAP_H
>  
>  #include <linux/linkage.h>
>  #include <asm/byteorder.h>
> @@ -78,4 +78,4 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
>  
>  #include <asm-generic/pci_iomap.h>
>  
> -#endif
> +#endif /* __GENERIC_IOMAP_H */
> 


-- 
Chen Gang
