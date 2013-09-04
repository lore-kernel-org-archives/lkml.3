Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942Ab3IDPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:16:26 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37398 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3IDPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:16:25 -0400
Message-ID: <52274EC6.1030100@linaro.org>
Date: Wed, 04 Sep 2013 11:16:22 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] edma: Update author email address
References: <20130904143250.GE12834@hansolo.jdub.homelinux.org>
In-Reply-To: <20130904143250.GE12834@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:32 AM, Josh Boyer wrote:
> Matt's @ti.com address bounces.  Update the MODULE_AUTHOR information in
> edma.c to his Linaro address.
>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>
> ---
> v2: Actually get the right email address....
>
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 5f3e532..574b1a7 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -667,6 +667,6 @@ static void __exit edma_exit(void)
>   }
>   module_exit(edma_exit);
>
> -MODULE_AUTHOR("Matt Porter <mporter@ti.com>");
> +MODULE_AUTHOR("Matt Porter <matt.porter@linaro.org>");
>   MODULE_DESCRIPTION("TI EDMA DMA engine driver");
>   MODULE_LICENSE("GPL v2");
>

Acked-by: Matt Porter <matt.porter@linaro.org>
