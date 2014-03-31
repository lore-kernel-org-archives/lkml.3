Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaCaPHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:07:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33169 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaPHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:07:02 -0400
Date: Mon, 31 Mar 2014 18:06:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rocco Folino <lordzen87@gmail.com>
Cc: aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] staging: octeon-usb: Fixed code style issues
Message-ID: <20140331150638.GQ6991@mwanda>
References: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, Andy,

On Mon, Mar 31, 2014 at 02:34:40PM +0200, Rocco Folino wrote:
> Fixed bit fields code style issues
> 
> Signed-off-by: Rocco Folino <lordzen87@gmail.com>
> ---
>  drivers/staging/octeon-usb/octeon-hcd.h | 486 ++++++++++++++++----------------
>  1 file changed, 243 insertions(+), 243 deletions(-)
> 
> diff --git a/drivers/staging/octeon-usb/octeon-hcd.h b/drivers/staging/octeon-usb/octeon-hcd.h
> index 42fe4fe..c534e317 100644
> --- a/drivers/staging/octeon-usb/octeon-hcd.h
> +++ b/drivers/staging/octeon-usb/octeon-hcd.h
> @@ -143,13 +143,13 @@ union cvmx_usbcx_gahbcfg {
>  	 *	* 1'b1: Unmask the interrupt assertion to the application.
>  	 */
>  	struct cvmx_usbcx_gahbcfg_s {
> -		uint32_t reserved_9_31	: 23;
> -		uint32_t ptxfemplvl	: 1;
> -		uint32_t nptxfemplvl	: 1;
> -		uint32_t reserved_6_6	: 1;
> -		uint32_t dmaen		: 1;
> -		uint32_t hbstlen	: 4;
> -		uint32_t glblintrmsk	: 1;
> +		uint32_t reserved_9_31:23;
> +		uint32_t ptxfemplvl:1;
> +		uint32_t nptxfemplvl:1;
> +		uint32_t reserved_6_6:1;
> +		uint32_t dmaen:1;
> +		uint32_t hbstlen:4;
> +		uint32_t glblintrmsk:1;
>  	} s;


The warning here is:

ERROR: spaces prohibited around that ':' (ctx:WxW)

I have done a kernel wide search for these warnings and I think we
should disable this warning.  It has too many false positives like this.

regards,
dan carpenter

