Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaEVUpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:45:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaEVUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:45:53 -0400
Date: Thu, 22 May 2014 23:44:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shiyan <shc_work@mail.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
Message-ID: <20140522204453.GN15585@mwanda>
References: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 07:51:19PM +0200, Emil Goode wrote:
> We forgot to free pdev->dev.dma_mask on error after
> having called the imx_alloc_mx3_camera function.
> This patch introduces the imx_free_mx3_camera function
> that adds the missing kfree call and is practical for
> future usage with imx_alloc_mx3_camera().
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Fantastic.  Thanks for this.  :)

regards,
dan carpenter

