Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3CRDNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:13:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65527 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CRDNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:13:15 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-27-514686495abf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Fabio Porcedda'" <fabio.porcedda@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Jeff Garzik'" <jgarzik@pobox.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-3-git-send-email-fabio.porcedda@gmail.com>
In-reply-to: <1363280978-24051-3-git-send-email-fabio.porcedda@gmail.com>
Subject: Re: [PATCH v2 2/8] drivers: ata: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 12:13:13 +0900
Message-id: <018c01ce2386$86c8f5f0$945ae1d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4g10UefkgB1OWXS7ijjwlSlFQ33wCrvyCA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zQ13PNrdAg1m/tCxO9H1gtTi24xGT
	xc1P31gtLu+aw2bRs2ErqwOrx+dNcgGMUVw2Kak5mWWpRfp2CVwZs24cYirYyFPx9e8h9gbG
	VVxdjJwcEgImEs+n7WGEsMUkLtxbz9bFyMUhJLCMUWLq8vPsMEWvJs2CSixilFh7ch4jhPOL
	UeLtl6Ng7WwCahJfvhwG6xAReA2U2JkCYjML1EnsmzmJCaKhnVFi+bQzzCAJTgFPiQutM9lA
	bGEBH4lDJ16DNbMIqErM2rAEqIGDg1fAVmL15GyQMK+AoMSPyfdYIGZqSazfeZwJwpaX2Lzm
	LTNIuYSAusSjv7ogpoiAkUT74WSIChGJfS/egZ0sIXCIXaLr2gRmiE0CEt8mH2KBaJWV2HSA
	GeJfSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3
	MUIicOIOxvsHrA8xJgOtn8gsJZqcD4zgvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwxv44bie4bK+jDNvq2q4pIvPfbJ58qOb29fa3B31LC4OW
	yLEwP8reunDxmqKvf8/bSLxTMbww++6F3oM9BXcUXsQp3v3V2rSYeZHNRb6/J/7Y/O9Wnj9F
	e4WexxGbdwGzs/U33Xdr6GvZrH6+JvbCtbKsNdNr44XPfvcWZdrQpbAxf+lq+9A3DEosxRmJ
	hlrMRcWJAInfv3vWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAV3PNrdAg5Pz1SxO9H1gtTi24xGT
	xc1P31gtLu+aw2bRs2ErqwOrx+dNcgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGbNuHGIq2MhT8fXvIfYGxlVcXYycHBICJhKvJs1ig7DFJC7cWw9kc3EICSxilFh7
	ch4jhPOLUeLtl6OMIFVsAmoSX74cZgexRQReAyV2poDYzAJ1EvtmTmKCaGhnlFg+7QwzSIJT
	wFPiQutMsBXCAj4Sh068BmtmEVCVmLVhCVADBwevgK3E6snZIGFeAUGJH5PvsUDM1JJYv/M4
	E4QtL7F5zVtmkHIJAXWJR391QUwRASOJ9sPJEBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWM
	LKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP7mfQOxlUNFocYBTgYlXh4DXhcA4VYE8uK
	K3MPMUpwMCuJ8DaEuAUK8aYkVlalFuXHF5XmpBYfYkwGenMis5Rocj4w9eSVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+MSYZNFAZ7bz75bLvx/R85sB41/
	J5+wTuh/sjpLZ5HGwRVO3u+LT1/V4L5os3BRi6SKdI+Zi9m6w1pz7128/EJ21jOLeImPjvv+
	+msaMW7Lm37gm+vZnzFBZt2Lph6aHpv948bsXZvPGv+69NLx8Gv7WQ1TLi875620dJHMyfaj
	P5oPztywM3KZshJLcUaioRZzUXEiALyKdrgzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 2:10 AM, Fabio Porcedda wrote:
> 
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: linux-ide@vger.kernel.org
> ---
>  drivers/ata/pata_at32.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

I already submitted the patch 2 weeks ago.

http://www.spinics.net/lists/linux-ide/msg45141.html

Best regards,
Jingoo Han

> 
> diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
> index 36f189c..8d493b4 100644
> --- a/drivers/ata/pata_at32.c
> +++ b/drivers/ata/pata_at32.c
> @@ -393,18 +393,7 @@ static struct platform_driver pata_at32_driver = {
>  	},
>  };
> 
> -static int __init pata_at32_init(void)
> -{
> -	return platform_driver_probe(&pata_at32_driver, pata_at32_probe);
> -}
> -
> -static void __exit pata_at32_exit(void)
> -{
> -	platform_driver_unregister(&pata_at32_driver);
> -}
> -
> -module_init(pata_at32_init);
> -module_exit(pata_at32_exit);
> +module_platform_driver_probe(pata_at32_driver, pata_at32_probe);
> 
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("AVR32 SMC/CFC PATA Driver");
> --
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

