Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3FEJdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:33:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36550 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3FEJdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:33:02 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130605093206.GQ28112@mwanda>
Date: Wed, 5 Jun 2013 02:32:07 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370422206-14961-4-git-send-email-of82ecuq@cip.cs.fau.de>
In-Reply-To: <1370422206-14961-4-git-send-email-of82ecuq@cip.cs.fau.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:50:03AM +0200, Johannes Schilling wrote:
> diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
> index a0fdffd..0e8ced1 100644
> --- a/drivers/staging/keucr/init.c
> +++ b/drivers/staging/keucr/init.c
> @@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
>  	int	result;
>  	BYTE	MiscReg03 = 0;
>  
> -	printk(KERN_INFO "--- Init Media ---\n");
> +	dev_info("--- Init Media ---\n");

Come on people, what's going on here?  This won't compile at all. :/

regards,
dan carpenter

