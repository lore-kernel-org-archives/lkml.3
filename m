Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3BCRAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:00:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:49480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3BCRAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:00:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198252154"
Date: Sun, 3 Feb 2013 18:00:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 08/10] mfd: wm5102: Refresh register defaults
Message-ID: <20130203170044.GG8476@sortiz-mobl>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359259652-8565-8-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359259652-8565-8-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jan 27, 2013 at 12:07:30PM +0800, Mark Brown wrote:
> The WM5102 register defaults are not up to date with the current register
> map, synchronise them with those for current devices.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |   95 +++++++++++++++----------------------------
>  1 file changed, 33 insertions(+), 62 deletions(-)

Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
