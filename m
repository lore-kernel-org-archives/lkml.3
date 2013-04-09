Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937550Ab3DIKTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:19:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:3662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935573Ab3DIKTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:19:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="224973559"
Date: Tue, 9 Apr 2013 12:18:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mfd: wm831x: use spi_get_drvdata() and
 spi_set_drvdata()
Message-ID: <20130409101857.GU24058@zurbaran>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Sat, Apr 06, 2013 at 03:42:48PM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
> can directly pass a struct spi_device.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/wm831x-spi.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
All 6 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
