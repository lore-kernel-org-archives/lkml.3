Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LMHzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:55:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18919 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab3LMHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:55:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 13 Dec 2013 15:27:12 +0800
From: Huang Shijie <b32955@freescale.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: Re: [PATCH] mtd: increase max page/OOB size to support 16K
 pagesize NAND
Message-ID: <20131213072705.GA28525@shlinux2.ap.freescale.net>
References: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47455@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 05:03:49AM +0000, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Fri, 13 Dec 2013 12:52:46 +0800
> Subject: [PATCH] mtd: increase max page/OOB size to support 16K pagesize NAND.
> 
> The Toshiba's TC58TEG5DCJTA pagesize is 16K, oob size is 1280 bytes.
> So increase the NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE.
> 
> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> ---
>  include/linux/mtd/nand.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index f3ea8da..2f0a7f2 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -56,8 +56,8 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
>   * is supported now. If you add a chip with bigger oobsize/page
>   * adjust this accordingly.
>   */
> -#define NAND_MAX_OOBSIZE	744
> -#define NAND_MAX_PAGESIZE	8192
> +#define NAND_MAX_OOBSIZE	1280
> +#define NAND_MAX_PAGESIZE	16384
maybe it is time to remove these two macros.

thanks
Huang Shijie

