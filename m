Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaLEM3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:29:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaLEM33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:29:29 -0500
Date: Fri, 5 Dec 2014 15:28:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: m.chehab@samsung.com, devel@driverdev.osuosl.org, gulsah.1004@gmail.com,
        gregkh@linuxfoundation.org, jarod@wilsonet.com,
        linux-kernel@vger.kernel.org, tuomas.tynkkynen@iki.fi,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/2] staging: media: lirc: lirc_zilog.c: keep
 consistency in dev functions
Message-ID: <20141205122855.GD4912@mwanda>
References: <20141204223524.GA17650@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204223524.GA17650@biggie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:35:24PM +0000, Luis de Bethencourt wrote:
> The previous patch switched some dev functions to move the string to a second
> line. Doing this for all similar functions because it makes the driver easier
> to read if all similar lines use the same criteria.
> 
> Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 155 +++++++++++++++++++++-----------
>  1 file changed, 102 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 8814a7e..af46827 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -322,7 +322,8 @@ static int add_to_buf(struct IR *ir)
>  	struct IR_tx *tx;
>  
>  	if (lirc_buffer_full(rbuf)) {
> -		dev_dbg(ir->l.dev, "buffer overflow\n");
> +		dev_dbg(ir->l.dev,
> +			"buffer overflow\n");

No.  Don't do this.  It's better if it is on one line.

regards,
dan carpenter

