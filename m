Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaBXKVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:21:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaBXKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:21:29 -0500
Date: Mon, 24 Feb 2014 13:21:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Roddick <dgroddick@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix coding style issues in poc.c
Message-ID: <20140224102112.GE26722@mwanda>
References: <1393235327-8546-1-git-send-email-dgroddick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393235327-8546-1-git-send-email-dgroddick@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You have not understood what Joe said.

On Mon, Feb 24, 2014 at 08:48:47PM +1100, David Roddick wrote:
> Removed unnecessary spaces after function pointer names and corrected multi-line wrap alignment
> 

This should be line wrapped at 72 characters (same rule as email).  In
other words it should take two lines like this:

Removed unnecessary spaces after function pointer names and corrected
multi-line wrap alignment.

> Signed-off-by: David Roddick <dgroddick@gmail.com>
> ---
>  drivers/staging/comedi/drivers/poc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
> index 2ae4ee1..514ccd8 100644
> --- a/drivers/staging/comedi/drivers/poc.c
> +++ b/drivers/staging/comedi/drivers/poc.c
> @@ -36,16 +36,16 @@ Configuration options:
>  struct boarddef_struct {
>  	const char *name;
>  	unsigned int iosize;
> -	int (*setup) (struct comedi_device *);
> +	int (*setup)(struct comedi_device *);
>  	int type;
>  	int n_chan;
>  	int n_bits;
> -	int (*winsn) (struct comedi_device *, struct comedi_subdevice *,
> -		      struct comedi_insn *, unsigned int *);
> -	int (*rinsn) (struct comedi_device *, struct comedi_subdevice *,
> -		      struct comedi_insn *, unsigned int *);
> -	int (*insnbits) (struct comedi_device *, struct comedi_subdevice *,
> -			 struct comedi_insn *, unsigned int *);
> +	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
> +		struct comedi_insn *, unsigned int *);

This is wrong.  It should be exactly like Joe said:

	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
		     struct comedi_insn *, unsigned int *);

[tab][tab][space][space][space][space][space]struct comedi_insn *,

Ideally it would have a variable name here, but since that wasn't there
in the original, we would accept the patch without it.  All the data
types are pretty clear what they are already, the only thing which is
not clear is what the last parameter does.

regards,
dan carpenter

