Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3BLKJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:09:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:38376 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab3BLKJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:09:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="290005448"
Date: Tue, 12 Feb 2013 11:09:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH 2/2] mfd: da9052-i2c: Staticize da9052_i2c_fix()
Message-ID: <20130212100934.GC20996@sortiz-mobl>
References: <1360615681-19909-1-git-send-email-festevam@gmail.com>
 <1360615681-19909-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360615681-19909-2-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Mon, Feb 11, 2013 at 06:48:01PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> da9052_i2c_fix() is only used locally, so let it be static.
> 
> Fix the following sparse warning:
> 
> drivers/mfd/da9052-i2c.c:63:5: warning: symbol 'da9052_i2c_fix' was not declared. Should it be static?
> 
> Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/da9052-i2c.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
