Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3BCRAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:00:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:45325 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab3BCRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:00:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="286033036"
Date: Sun, 3 Feb 2013 18:00:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: Re: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
Message-ID: <20130203170027.GE8476@sortiz-mobl>
References: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tue, Jan 08, 2013 at 02:01:22PM +0530, Sachin Kamat wrote:
> devm_regulator_bulk_get is device managed and saves some cleanup
> and exit code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Compile tested against linux-next tree (20130108).
> ---
>  drivers/mfd/wm8994-core.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
