Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab3BLKJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:09:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:10324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660Ab3BLKJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:09:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="284616075"
Date: Tue, 12 Feb 2013 11:09:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: Re: [PATCH 1/2] mfd: syscon: Fix sparse warning
Message-ID: <20130212100908.GB20996@sortiz-mobl>
References: <1360615681-19909-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360615681-19909-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Mon, Feb 11, 2013 at 06:48:00PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following sparse warnings:
> 
> drivers/mfd/syscon.c:40:15: warning: symbol 'syscon_node_to_regmap' was not declared. Should it be static?
> drivers/mfd/syscon.c:56:15: warning: symbol 'syscon_regmap_lookup_by_compatible' was not declared. Should it be static?
> drivers/mfd/syscon.c:72:15: warning: symbol 'syscon_regmap_lookup_by_phandle' was not declared. Should it be static?
> 
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/syscon.c |    1 +
>  1 file changed, 1 insertion(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
