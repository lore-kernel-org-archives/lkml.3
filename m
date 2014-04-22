Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaDVWDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:03:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42219 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbaDVWDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:03:46 -0400
Date: Wed, 23 Apr 2014 01:03:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] Staging: rts5139: Camel case labels replaced
Message-ID: <20140422220330.GP26890@mwanda>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
 <1398201784-7602-2-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398201784-7602-2-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:22:59PM +0200, Fabio Falzoi wrote:
> @@ -316,7 +316,7 @@ static int rts51x_control_thread(void *__chip)
>  		if (chip->srb->result != DID_ABORT << 16)
>  			chip->srb->scsi_done(chip->srb);
>  		else
> -SkipForAbort :
> +abort :

Just a comment (no need to resend).  Next time remove the space before
the colon.

abort:

regards,
dan carpenter

