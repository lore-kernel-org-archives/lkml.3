Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3LUKw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:52:58 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38645 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3LUKw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:52:56 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:52:47 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: dwc2: Mark function as static in core.c
Message-ID: <20131221105246.GD3611@leaf>
References: <20131221102029.GA3151@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221102029.GA3151@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:50:29PM +0530, Rashika Kheria wrote:
> Mark function dwc2_set_param_uframe_sched() as static in core.c because
> it is not used outside this file.
> 
> This eliminates the following warning in core.c:
> drivers/staging/dwc2/core.c:2739:5: warning: no previous prototype for ‘dwc2_set_param_uframe_sched’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/dwc2/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
> index 6d001b5..c029cb6 100644
> --- a/drivers/staging/dwc2/core.c
> +++ b/drivers/staging/dwc2/core.c
> @@ -2736,7 +2736,7 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
>  	return 0;
>  }
>  
> -int dwc2_set_param_uframe_sched(struct dwc2_hsotg *hsotg, int val)
> +static int dwc2_set_param_uframe_sched(struct dwc2_hsotg *hsotg, int val)
>  {
>  	int retval = 0;
>  
> -- 
> 1.7.9.5
> 
