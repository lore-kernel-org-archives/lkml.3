Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3BCWb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:31:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:57105 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab3BCWbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:31:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198290507"
Date: Sun, 3 Feb 2013 23:31:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm5102: Make DSP scratch registers readable
Message-ID: <20130203223152.GW8476@sortiz-mobl>
References: <1359104964-27041-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359104964-27041-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 25, 2013 at 05:09:23PM +0800, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |    8 ++++++++
>  include/linux/mfd/arizona/registers.h |   16 ++++++++++++++++
>  2 files changed, 24 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
