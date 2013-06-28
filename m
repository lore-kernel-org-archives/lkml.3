Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3F1Pih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:38:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:31655 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab3F1Pig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:38:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="261439843"
Date: Fri, 28 Jun 2013 17:35:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: sec: Remove fields not used since regmap conversion
Message-ID: <20130628153548.GB13700@zurbaran>
References: <1372428743-31687-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372428743-31687-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jun 28, 2013 at 03:12:23PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> These were all used by the open coded I/O and IRQ implementations and are
> no longer referenced now that the regmap core variants are used instead.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  include/linux/mfd/samsung/core.h | 6 ------
>  1 file changed, 6 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
