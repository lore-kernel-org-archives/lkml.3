Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaEWGu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:50:58 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50888 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEWGu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:50:56 -0400
Message-ID: <537EEFCE.8000201@gmail.com>
Date: Fri, 23 May 2014 08:50:54 +0200
From: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Emil Goode <emilgoode@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shiyan <shc_work@mail.ru>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
References: <1400781080-6117-1-git-send-email-emilgoode@gmail.com> <20140522181024.GA20155@pengutronix.de>
In-Reply-To: <20140522181024.GA20155@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe

Le 22/05/2014 20:10, Uwe Kleine-König a écrit :
[...]
> Today all imx machines should get their devices from an oftree, so
> the various functions to add devices started to bitrot. Moreover
> there is no reason to remove a device once it was successfully
> added.
>
> Note that platform_device_register_full has the same problem (i.e.
> pdev->dev.dma_mask isn't freed when the last reference to a device
> is dropped.) You'd do a better deed if you picked up
> http://thread.gmane.org/gmane.linux.kernel/1613364/focus=1635995
> instead of fixing dead code.

I would like to object that all imx machine should now boot from devicetree.
mx31moboard is still used and still get its kernel updated.
It has never booted from devicetree, and IIRC the "deal" when devicetree
was enforced on ARM was that all previous boards where still supported
and would not get removed.
So please don't kick us out of the kernel so fast :)

Thanks !

Philippe
