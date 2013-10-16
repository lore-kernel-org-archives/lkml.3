Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab3JPTeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:34:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3JPTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:34:45 -0400
Date: Wed, 16 Oct 2013 12:34:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, wfp5p@virginia.edu,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: fix semicolon coding style issue in
 ni_660x.c
Message-ID: <20131016193444.GA13378@kroah.com>
References: <1381951492-20654-1-git-send-email-dhanunjaya.matrix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381951492-20654-1-git-send-email-dhanunjaya.matrix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:54:52AM +0530, Dhanunjaya Naidu Ravada wrote:
> From: Dhanunjaya <dhanunjaya.matrix@gmail.com>

Again, doesn't match the signed-off-by: or From: line on your email :(

> This is a patch to the ni_660x.c file that fixes up a semicolon warning
> found by the checkpatch.pl tool.

No it isn't, it also does something else in this file.

> 
> Signed-off-by: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_660x.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
> index 3607336..95bb432 100644
> --- a/drivers/staging/comedi/drivers/ni_660x.c
> +++ b/drivers/staging/comedi/drivers/ni_660x.c
> @@ -28,7 +28,7 @@
>   *
>   * Encoders work.  PulseGeneration (both single pulse and pulse train)
>   * works.  Buffered commands work for input but not output.
> - * 
> + *

That doesn't look like a semicolon fix.

>   * References:
>   * DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
>   * DAQ 6601/6602 User Manual (NI 322137B-01)
> @@ -1232,7 +1232,7 @@ static int ni_660x_auto_attach(struct comedi_device *dev,
>  			s->type = COMEDI_SUBD_COUNTER;
>  			s->subdev_flags =
>  			    SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL |
> -			    SDF_CMD_READ /* | SDF_CMD_WRITE */ ;
> +			    SDF_CMD_READ; /* | SDF_CMD_WRITE */

Nope, please leave the original code, it's correct.

greg k-h
