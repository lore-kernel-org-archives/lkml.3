Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaATJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:09:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27236 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaATJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:09:34 -0500
Date: Mon, 20 Jan 2014 12:09:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging : comedi : comedidev.h Fixed warning space
 coding style issue
Message-ID: <20140120090933.GU7444@mwanda>
References: <1390205949-12102-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390205949-12102-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 12:19:09AM -0800, Surendra Patil wrote:
> Fixed a coding style issue,removed space after the function pointer name
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index f82bd42..588e9e7 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -61,29 +61,29 @@ struct comedi_subdevice {
>  
>  	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
>  
> -	int (*insn_read) (struct comedi_device *, struct comedi_subdevice *,
> +	int (*insn_read)(struct comedi_device *, struct comedi_subdevice *,
>  			  struct comedi_insn *, unsigned int *);

Now the the second line has one extra space.  The 's' characters in
"struct comedi_device *" and "struct comedi_insn *" should be on the
same column.

regards,
dan carpenter

