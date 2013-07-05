Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3GEBIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:08:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58135 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3GEBIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:08:44 -0400
Message-ID: <51D61C4D.4070501@gmail.com>
Date: Fri, 05 Jul 2013 09:07:25 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "'Jiri Kosina'" <trivial@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] include/asm-generic/iomap.h: trivial: use '__ASM_GENERIC_IOMAP_H'
 instead of '__GENERIC_IO_H'
References: <51CCF58E.9000007@asianux.com> <51CCF659.7070908@asianux.com> <51CCF6E1.3080200@asianux.com>
In-Reply-To: <51CCF6E1.3080200@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainers:

Please help check this patch whether OK, when you have time.

Thanks.

On 06/28/2013 10:37 AM, Chen Gang wrote:
> Recommend to let the header file macro mark match the file name.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/asm-generic/iomap.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index 6afd7d6..facfb39 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -1,5 +1,5 @@
> -#ifndef __GENERIC_IO_H
> -#define __GENERIC_IO_H
> +#ifndef __ASM_GENERIC_IOMAP_H
> +#define __ASM_GENERIC_IOMAP_H
>  
>  #include <linux/linkage.h>
>  #include <asm/byteorder.h>
> @@ -78,4 +78,4 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
>  
>  #include <asm-generic/pci_iomap.h>
>  
> -#endif
> +#endif /* __ASM_GENERIC_IOMAP_H */
> 


-- 
Chen Gang
