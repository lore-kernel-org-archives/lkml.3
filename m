Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbbAZLby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:31:54 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:40791 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbbAZLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:31:50 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C625A3.4020001@mev.co.uk>
Date: Mon, 26 Jan 2015 11:31:47 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 01/03] STAGING: Fix pcl818.c coding style issue:
 code indent should use tabs where possible
References: <20150125092816.GA4076@thunderCat>
In-Reply-To: <20150125092816.GA4076@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/15 09:28, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - code indent should use tabs where possible
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index ba2e137..72a700c 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -45,11 +45,11 @@ A word or two about DMA. Driver support DMA operations at two ways:
>       [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>       [2] - DMA	(0=disable, 1, 3)
>       [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +	      1= 1MHz clock for 8254
>       [4] - 0,  5=A/D input  -5V.. +5V
> -          1, 10=A/D input -10V..+10V
> +	  1, 10=A/D input -10V..+10V
>       [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> +	  1, 10=D/A output 0-10V (internal reference -10V)
>   	  2    =D/A output unknown (external reference)
>
>      Options for PCL-818, PCL-818H:
> @@ -57,28 +57,28 @@ A word or two about DMA. Driver support DMA operations at two ways:
>       [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>       [2] - DMA	(0=disable, 1, 3)
>       [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +	      1= 1MHz clock for 8254
>       [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> +	  1, 10=D/A output 0-10V (internal reference -10V)
>   	  2    =D/A output unknown (external reference)
>
>      Options for PCL-818HD, PCL-818HG:
>       [0] - IO Base
>       [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>       [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
> -                      1=use DMA ch 1, 3=use DMA ch 3)
> +		      1=use DMA ch 1, 3=use DMA ch 3)
>       [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +	      1= 1MHz clock for 8254
>       [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> -   	  2    =D/A output unknown (external reference)
> +	  1, 10=D/A output 0-10V (internal reference -10V)
> +	  2    =D/A output unknown (external reference)
>
>      Options for PCL-718:
>       [0] - IO Base
>       [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>       [2] - DMA	(0=disable, 1, 3)
>       [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +	      1= 1MHz clock for 8254
>       [4] -     0=A/D Range is +/-10V
>   	      1=             +/-5V
>   	      2=             +/-2.5V
> @@ -87,14 +87,14 @@ A word or two about DMA. Driver support DMA operations at two ways:
>   	      5=  	     user defined bipolar
>   	      6=	     0-10V
>   	      7=	     0-5V
> - 	      8=	     0-2V
> +	      8=	     0-2V
>   	      9=	     0-1V
>   	     10=	     user defined unipolar
>       [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
> -          1, 10=D/A outputs 0-10V (internal reference -10V)
> +	  1, 10=D/A outputs 0-10V (internal reference -10V)
>   	      2=D/A outputs unknown (external reference)
>       [6] - 0, 60=max  60kHz A/D sampling
> -          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
> +	  1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
>
>   */

Okay, but this comment block really needs reformatting to use the usual 
block comment style, and with spaces to line up the columns instead of 
tabs so it still looks okay when the " * " is removed from the start of 
each line of the block comment.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
