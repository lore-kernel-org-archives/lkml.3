Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaLDIQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:16:17 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:52811 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaLDIQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:16:15 -0500
Date: Thu, 04 Dec 2014 17:15:17 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uapi: fix to export linux/vm_sockets.h
Cc: netdev@vger.kernel.org, Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Piotr Krol <piotr.krol@3mdeb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org
In-Reply-To: <1417396577-32499-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417396577-32499-1-git-send-email-yamada.m@jp.panasonic.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141204171516.E206.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Is there a chance to fix this by the Linux 3.18 release?

Thanks.




On Mon,  1 Dec 2014 10:16:17 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> A typo "header=y" was introduced by commit 7071cf7fc435
> (uapi: add missing network related headers to kbuild).
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> ---
> 
>  include/uapi/linux/Kbuild | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 4c94f31..8523f9b 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -427,7 +427,7 @@ header-y += virtio_net.h
>  header-y += virtio_pci.h
>  header-y += virtio_ring.h
>  header-y += virtio_rng.h
> -header=y += vm_sockets.h
> +header-y += vm_sockets.h
>  header-y += vt.h
>  header-y += wait.h
>  header-y += wanrouter.h
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


