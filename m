Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaLCWNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:13:22 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57136 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaLCWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:21 -0500
Date: Thu, 4 Dec 2014 00:13:07 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Jamie Lawler <jamie.lawler@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon: Added several blank lines after
 declarations
Message-ID: <20141203221307.GC14524@fuloong-minipc.musicnaut.iki.fi>
References: <1417643031-26190-1-git-send-email-jamie.lawler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417643031-26190-1-git-send-email-jamie.lawler@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 03, 2014 at 09:43:51PM +0000, Jamie Lawler wrote:
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -84,6 +84,7 @@ static int cvm_irq_cpu;
>  static void cvm_oct_enable_napi(void *_)
>  {
>  	int cpu = smp_processor_id();
> +
>  	napi_schedule(&cvm_oct_napi[cpu].napi);
>  }

This function has already been deleted from the staging tree.
You need to refresh your patch and see if it's still relevant for
the current tree.

A.
