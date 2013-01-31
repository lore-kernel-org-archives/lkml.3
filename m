Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3AaLCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:02:52 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:53382 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab3AaLCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:02:49 -0500
Message-ID: <510A4F52.7050008@mev.co.uk>
Date: Thu, 31 Jan 2013 11:02:42 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.nl>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: made range.c checkpatch.pl compliant
References: <20130131105648.GB18894@f-lin01.localdomain>
In-Reply-To: <20130131105648.GB18894@f-lin01.localdomain>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-31 10:56, Sebastiaan de Haan wrote:
> Change made to range.c to make it checkpatch.pl compliant
>
> Signed-off-by: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.nl>
> ---
>   drivers/staging/comedi/range.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
> index 59ff0cf..b87fb4e 100644
> --- a/drivers/staging/comedi/range.c
> +++ b/drivers/staging/comedi/range.c
> @@ -35,7 +35,7 @@ const struct comedi_lrange range_unipolar10 = { 1, {UNI_RANGE(10)} };
>   EXPORT_SYMBOL(range_unipolar10);
>   const struct comedi_lrange range_unipolar5 = { 1, {UNI_RANGE(5)} };
>   EXPORT_SYMBOL(range_unipolar5);
> -const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
> +const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_NONE} } };
>   EXPORT_SYMBOL(range_unknown);

No, no, no.  It doesn't compile and UNIT_none is used by user space.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
