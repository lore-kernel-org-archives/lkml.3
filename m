Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3BCRAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:00:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:26990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3BCRAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:00:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="286032955"
Date: Sun, 3 Feb 2013 18:00:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Register MICVDD supply first to ensure no
 retries
Message-ID: <20130203170013.GC8476@sortiz-mobl>
References: <1356017883-17588-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356017883-17588-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Dec 20, 2012 at 03:38:03PM +0000, Mark Brown wrote:
> Not strictly required as probe deferral will take care of everything but
> it makes boot a little smoother.
> 
> Reported-by: Ryo Tsutsui <Ryo.Tsutsui@wolfsonmicro.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
