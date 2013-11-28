Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab3K1Ek0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:40:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35429 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3K1EkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:40:24 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-db-5296c9372738
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Evgeniy Polyakov'" <zbr@ioremap.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004e01ceebec$52ed0f80$f8c72e80$%han@samsung.com>
In-reply-to: <004e01ceebec$52ed0f80$f8c72e80$%han@samsung.com>
Subject: Re: [PATCH] w1: matrox: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 13:40:23 +0900
Message-id: <005801ceebf3$f3695570$da3c0050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r7FLGMO75lsWtQoOv/j+n0ORRdgAB469w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY13zk9OCDH5NUrWYs34Nm8XlhZdY
	LS7vmsNm8Wv1OTYHFo/HO7YzeZyY8ZvFo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJ+PGph
	L5jHVfFw7iXWBsb1HF2MnBwSAiYSc579ZYWwxSQu3FvP1sXIxSEksIxR4sXvr8wwRctXfASz
	hQQWMUqsWlYJUfSLUeLorn6wbjYBNYkvXw6zdzFycIgI6Eu0tWiAhJkFciTurHoH1WsrsefK
	dnYQm1PATmLu86esIOXCAk4SOzqrQcIsAqoSH69cB5vIC1T+6Pp9KFtQ4sfkeywQI7Uk1u88
	zgRhy0tsXvOWGWSMhIC6xKO/uiBhEQEjiUkv7jFDlIhI7HvxjhHkYgmBc+wSdydNYIPYJSDx
	bfIhFoheWYlNB6C+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQrzgx
	t7g0L10vOT93EyMkInt3MN4+YH2IMRlo/URmKdHkfGBE55XEGxqbGVmYmpgaG5lbmpEmrCTO
	m/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY2FOv9kDf7lsS33uaaskXpfGHXrx9d03
	naXz0kSWX4rvcLl3IueM4dmTHPe6kmeIbnPiWdLFcr9cwWtihctjjXML1756ZWd8LHpKZP7X
	XJ5n2dO3nu44Ki92tbflvUfQne4k7s6c3d971wecmqZb6HR/Q8pB5uUL7t7ZHJtx5/HEhAM8
	MrqPfyuxFGckGmoxFxUnAgDz2iOL3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV3zk9OCDGatVLSYs34Nm8XlhZdY
	LS7vmsNm8Wv1OTYHFo/HO7YzeZyY8ZvFo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzfjxqYS+Yx1XxcO4l1gbG9RxdjJwcEgImEstXfGSGsMUkLtxb
	zwZiCwksYpRYtayyi5ELyP7FKHF0Vz8rSIJNQE3iy5fD7F2MHBwiAvoSbS0aIGFmgRyJO6ve
	MUP02krsubKdHcTmFLCTmPv8KStIubCAk8SOzmqQMIuAqsTHK9fBJvIClT+6fh/KFpT4Mfke
	C8RILYn1O48zQdjyEpvXvGUGGSMhoC7x6K8uSFhEwEhi0ot7zBAlIhL7XrxjnMAoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj/Zn0DsZVDRaHGAU4GJV4
	eCV0pgUJsSaWFVfmHmKU4GBWEuFVKAYK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wFeWV
	xBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6NFbPjHS9kXcs9m
	J+0Xdtl4vzRR4X5RcPgpsyczhQ3aeC7uvmTm/r5J4+VNY47Onransp8nc6qrXr0jmXehu+IF
	f/6FM3Xl8nOD57ff/brDJvLhQmN7L9Wit68Cvwspe+Q+XMz8xSjEKv/Q0v1KX/3MC+9m7s+c
	xvv5QoziozcModtWNOkp/VNiKc5INNRiLipOBACxEZ8BOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 12:46 PM, Jingoo Han wrote:
> 
> This macro is used to create a struct pci_device_id array.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Please, ignore these patches.
According to the Greg Kroah-Hartman, 

"Yeah, and it's a horrid macro that deserves to be removed, please don't
use it in more places.

Actually, if you could just remove it, that would be best, sorry, I'm
not going to take these patches."

So, I will send the patch to remove 'DEFINE_PCI_DEVICE_TABLE' instead.
Sorry for annoying. :-)

Best regards,
Jingoo Han


> ---
>  drivers/w1/masters/matrox_w1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/w1/masters/matrox_w1.c b/drivers/w1/masters/matrox_w1.c
> index d8667b0..9361cea 100644
> --- a/drivers/w1/masters/matrox_w1.c
> +++ b/drivers/w1/masters/matrox_w1.c
> @@ -42,7 +42,7 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
>  MODULE_DESCRIPTION("Driver for transport(Dallas 1-wire prtocol) over VGA DDC(matrox gpio).");
> 
> -static struct pci_device_id matrox_w1_tbl[] = {
> +static DEFINE_PCI_DEVICE_TABLE(matrox_w1_tbl) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_MATROX, PCI_DEVICE_ID_MATROX_G400) },
>  	{ },
>  };
> --
> 1.7.10.4


