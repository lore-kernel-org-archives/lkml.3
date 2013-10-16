Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784Ab3JPOHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:07:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52516 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934444Ab3JPOHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:07:23 -0400
Message-ID: <525E9D95.7040304@mev.co.uk>
Date: Wed, 16 Oct 2013 15:07:17 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dhanunjaya <dhanunjaya.matrix@gmail.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "wfp5p@virginia.edu" <wfp5p@virginia.edu>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: fix semicolon coding style issue in
 ni_660x.c
References: <1381927094-13457-1-git-send-email-dhanunjaya.matrix@gmail.com>
In-Reply-To: <1381927094-13457-1-git-send-email-dhanunjaya.matrix@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-16 13:38, Dhanunjaya wrote:
> This is a patch to the ni_660x.c file that fixes up a semicolon warning
> found by the checkpatch.pl tool
> ---
>   drivers/staging/comedi/drivers/ni_660x.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
> index 3607336..95bb432 100644
> --- a/drivers/staging/comedi/drivers/ni_660x.c
> +++ b/drivers/staging/comedi/drivers/ni_660x.c
> @@ -28,7 +28,7 @@
>    *
>    * Encoders work.  PulseGeneration (both single pulse and pulse train)
>    * works.  Buffered commands work for input but not output.
> - *
> + *
>    * References:
>    * DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
>    * DAQ 6601/6602 User Manual (NI 322137B-01)
> @@ -1232,7 +1232,7 @@ static int ni_660x_auto_attach(struct comedi_device *dev,
>   			s->type = COMEDI_SUBD_COUNTER;
>   			s->subdev_flags =
>   			    SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL |
> -			    SDF_CMD_READ /* | SDF_CMD_WRITE */ ;
> +			    SDF_CMD_READ; /* | SDF_CMD_WRITE */
>   			s->n_chan = 3;
>   			s->maxdata = 0xffffffff;
>   			s->insn_read = ni_660x_GPCT_rinsn;
>

Looks good!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
