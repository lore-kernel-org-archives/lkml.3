Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaESQvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:51:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58505 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaESQvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:51:45 -0400
Message-ID: <537A3696.6080902@mev.co.uk>
Date: Mon, 19 May 2014 17:51:34 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        Ian Abbott <Ian.Abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: comedi: ii_pci20kc: fix usage of uninit scalar
 in ii20k_attach()
References: <20140507214552.0d2d72b2@spike>
In-Reply-To: <20140507214552.0d2d72b2@spike>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-07 20:45, Christian Engelmayer wrote:
> This driver supports the PCI-20001C-1a and PCI-20001C-2a carrier boards.
> The -2a version has 32 on-board DIO channels. In case this variant is
> detected, local variable 'has_dio' is set accordingly. Otherwise it is
> left uninitialized and the following subdevice instantiation depends on
> the stack. Detected by Coverity - CID 1077830.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> v2: Resend after v1 failed to apply
>
>     * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
>       Remove 'u8 *pbuf' from struct recv_buf)
>     * fixed mua: no multipart, 7bit text/plain us-ascii
>
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>   drivers/staging/comedi/drivers/ii_pci20kc.c | 1 +
>   1 file changed, 1 insertion(+)

Thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
