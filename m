Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaAJKdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:33:36 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39798 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaAJKdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:33:32 -0500
Message-ID: <52CFCC79.5050307@mev.co.uk>
Date: Fri, 10 Jan 2014 10:33:29 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Kwiatkowski <michaelflowersky@geekingspree.com>,
        Ian Abbott <ian.abbott@mev.co.uk>
CC: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: amcc_s5933: "no space before tabs" coding
 style fixes.
References: <1389308335-6724-1-git-send-email-michaelflowersky@geekingspree.com>
In-Reply-To: <1389308335-6724-1-git-send-email-michaelflowersky@geekingspree.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-09 22:58, Michal Kwiatkowski wrote:
> Fixed a coding style issues.
>
> Signed-off-by: Michal Kwiatkowski <michaelflowersky@geekingspree.com>
> ---
>   drivers/staging/comedi/drivers/amcc_s5933.h |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/amcc_s5933.h b/drivers/staging/comedi/drivers/amcc_s5933.h
> index b810d5f..2ba7364 100644
> --- a/drivers/staging/comedi/drivers/amcc_s5933.h
> +++ b/drivers/staging/comedi/drivers/amcc_s5933.h
> @@ -145,12 +145,12 @@
>   #define AINT_READ_COMPL		0x00008000
>   #define AINT_WRITE_COMPL	0x00004000
>
> -#define AINT_OMB_ENABLE 	0x00001000
> -#define AINT_OMB_SELECT 	0x00000c00
> +#define AINT_OMB_ENABLE		0x00001000
> +#define AINT_OMB_SELECT		0x00000c00
>   #define AINT_OMB_BYTE		0x00000300
>
> -#define AINT_IMB_ENABLE 	0x00000010
> -#define AINT_IMB_SELECT 	0x0000000c
> +#define AINT_IMB_ENABLE		0x00000010
> +#define AINT_IMB_SELECT		0x0000000c
>   #define AINT_IMB_BYTE		0x00000003
>
>   /* these are bits from various different registers, needs cleanup XXX */
>

Harmless.  (Good!)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
