Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaEAJFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:05:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55804 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbaEAJFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:05:35 -0400
Message-ID: <53620E50.8000406@mev.co.uk>
Date: Thu, 1 May 2014 10:05:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Raghavendra Ganiga <ravi23ganiga@gmail.com>,
        <hsweeten@visionengravers.com>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c
References: <1398932592-17768-1-git-send-email-ravi23ganiga@gmail.com>
In-Reply-To: <1398932592-17768-1-git-send-email-ravi23ganiga@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/05/01 09:23 AM, Raghavendra Ganiga wrote:
> This is a patch to fix coding style
> warnings found by checkpatch.pl tool
> 
> Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index 70545e6..b24bf9b 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -668,6 +668,7 @@ static int do_devconfig_ioctl(struct comedi_device *dev,
>  			return -EBUSY;
>  		if (dev->attached) {
>  			struct module *driver_module = dev->driver->module;
> +
>  			comedi_device_detach(dev);
>  			module_put(driver_module);
>  		}
> @@ -2653,6 +2654,7 @@ static int __init comedi_init(void)
>  	/* create devices files for legacy/manual use */
>  	for (i = 0; i < comedi_num_legacy_minors; i++) {
>  		struct comedi_device *dev;
> +
>  		dev = comedi_alloc_board_minor(NULL);
>  		if (IS_ERR(dev)) {
>  			comedi_cleanup_board_minors();
> 

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
