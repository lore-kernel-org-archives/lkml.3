Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3H2Xbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:31:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab3H2Xbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:31:43 -0400
Message-ID: <521FD9C0.6020302@ti.com>
Date: Thu, 29 Aug 2013 18:31:12 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
References: <1377818873-21174-1-git-send-email-joelf@ti.com> <1377818873-21174-2-git-send-email-joelf@ti.com>
In-Reply-To: <1377818873-21174-2-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 06:27 PM, Joel Fernandes wrote:
> Add omap-des driver with platform data for OMAP4. Support added for DES
> ECB and CBC modes.
> 
> Where possible, code is reused from omap-aes driver with changes made for
> adjusting key size, block size, removing non-existent encryption modes
> and adding support for OMAP4 platform data and offsets.
> 
> Tests have been conducted with the CRYPTO test manager, and functionality
> is verified at different page length alignments.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/crypto/omap-des.c | 1192 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 1192 insertions(+)
>  create mode 100644 drivers/crypto/omap-des.c
> 
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> new file mode 100644
> index 0000000..6a9a25f
> --- /dev/null
> +++ b/drivers/crypto/omap-des.c
> @@ -0,0 +1,1192 @@
> +/*
> + * Cryptographic API.
> + *
> + * Support for OMAP DES and Triple DES HW acceleration.
> + *
> + * Copyright (c) 2012 Texas Instruments Incorporated
> + * Author: Joel Fernandes <joelf@ti.com>

Have to change this to 2013. Will do so if there are no other comments.

Regards,

-Joel

