Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbaGWOIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:08:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47700 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGWOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:08:46 -0400
Date: Wed, 23 Jul 2014 17:08:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sudip <sudipm.mukherjee@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm : Transmit.c : fixed coding style problem
Message-ID: <20140723140840.GU25880@mwanda>
References: <1406123550-11951-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406123550-11951-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject is too general.  Which coding style issue did you fix?

On Wed, Jul 23, 2014 at 07:22:30PM +0530, sudip wrote:

Use your full name.  "Sudip Mukherjee" not just "sudip".

> applies to next-20140723

Leave this out.

> 
> 
> Signed-off-by: sudip <sudipm.mukherjee@gmail.com>

Use your real name again.

> ---
>  drivers/staging/bcm/Transmit.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
> index 05fae92..10586f8 100644
> --- a/drivers/staging/bcm/Transmit.c
> +++ b/drivers/staging/bcm/Transmit.c
> @@ -89,7 +89,8 @@ int SendControlPacket(struct bcm_mini_adapter *Adapter, char *pControlPacket)
>   * to the target via the host h/w interface.
>   * @return  zero(success) or -ve value(failure)
>   */
> -int SetupNextSend(struct bcm_mini_adapter *Adapter,  struct sk_buff *Packet, USHORT Vcid)
> +int SetupNextSend(struct bcm_mini_adapter *Adapter,
> +		struct sk_buff *Packet, USHORT Vcid)
>  {
>  	int	status = 0;
>  	bool	bHeaderSupressionEnabled = false;
> @@ -205,7 +206,8 @@ int tx_pkt_handler(struct bcm_mini_adapter *Adapter)
>  	int status = 0;
>  
>  	while (!kthread_should_stop()) {
> -		/* FIXME - the timeout looks like workaround for racey usage of TxPktAvail */
> +		/* FIXME - the timeout looks like workaround
> +		   for racey usage of TxPktAvail */

This is not proper style for muti-line comments.

regards,
dan carpenter

