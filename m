Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbbAHJNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:13:32 -0500
Received: from sym2.noone.org ([178.63.92.236]:38971 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbbAHJN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:13:27 -0500
Date: Thu, 8 Jan 2015 10:13:23 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Aaron Wu <Aaron.wu@analog.com>
Cc: mkl@pengutronix.de, wg@grandegger.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net
Subject: Re: [PATCH V2 2/2] bfin_can: rewrite the driver to support the common
Message-ID: <20150108091322.GE9157@distanz.ch>
References: <1420700254-22529-1-git-send-email-Aaron.wu@analog.com>
 <1420700254-22529-2-git-send-email-Aaron.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420700254-22529-2-git-send-email-Aaron.wu@analog.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-08 at 07:57:34 +0100, Aaron Wu <Aaron.wu@analog.com> wrote:
> Rewrite the driver to comply to common style with MMU 
> 
> Signed-off-by: Aaron Wu <Aaron.wu@analog.com>
> ---
>  drivers/net/can/bfin_can.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/can/bfin_can.c b/drivers/net/can/bfin_can.c
> index 0a5eff4..1d116a7 100644
> --- a/drivers/net/can/bfin_can.c
> +++ b/drivers/net/can/bfin_can.c
[...]
> @@ -617,9 +615,6 @@ static int bfin_can_remove(struct platform_device *pdev)
>  
>  	unregister_candev(dev);
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, resource_size(res));
> -

struct resource *res will be unused in bfin_can_remove() after this
change, so it should be removed as well.
