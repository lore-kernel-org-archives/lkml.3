Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3JYWfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:35:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:52236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3JYWfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="380176324"
Date: Sat, 26 Oct 2013 00:35:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: as3722: Don't export the regmap config
Message-ID: <20131025223514.GB23710@zurbaran>
References: <1382731800-19663-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382731800-19663-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 25, 2013 at 09:10:00PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> It's not used outside this file so can be static.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/as3722.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
