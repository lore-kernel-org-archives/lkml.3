Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab3GAXBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 19:01:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:40167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3GAXBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 19:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,976,1363158000"; 
   d="scan'208";a="262826088"
Date: Tue, 2 Jul 2013 00:56:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: sec: Provide max_register to regmap
Message-ID: <20130701225605.GD4572@zurbaran>
References: <1372716139-5586-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372716139-5586-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 01, 2013 at 11:02:19PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Enable debugfs register dumps and greater error checking within the
> regmap API providing the maximum register to the regmap API.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/sec-core.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
