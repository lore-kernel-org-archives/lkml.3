Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3COJlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:41:14 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38456 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab3COJlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:41:12 -0400
Message-ID: <5142ECB1.306@mev.co.uk>
Date: Fri, 15 Mar 2013 09:41:05 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130313 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kumar Amit Mehta <gmate.amit@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: drivers: ni_atmio.c: Add a missing semicolon
References: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
In-Reply-To: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-15 08:14, Kumar Amit Mehta wrote:
> fix a missing end-of-statement by adding a semicolon.
>
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>   drivers/staging/comedi/drivers/ni_atmio.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
> index 279f2cd..37372a1 100644
> --- a/drivers/staging/comedi/drivers/ni_atmio.c
> +++ b/drivers/staging/comedi/drivers/ni_atmio.c
> @@ -467,7 +467,7 @@ static int ni_atmio_attach(struct comedi_device *dev,
>   		return -EIO;
>
>   	dev->board_ptr = ni_boards + board;
> -	boardtype = comedi_board(dev)
> +	boardtype = comedi_board(dev);
>
>   	printk(" %s", boardtype->name);
>   	dev->board_name = boardtype->name;

Ironically, that was introduced by a patch titled "staging: comedi: 
ni_atmio: fix build errors". :-)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
