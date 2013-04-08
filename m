Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936814Ab3DHQBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:01:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:34480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936512Ab3DHQBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="319177201"
Date: Mon, 8 Apr 2013 18:01:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [Patch V4 1/2] mfd: tps65090: Fix enum in header file
Message-ID: <20130408160109.GZ24058@zurbaran>
References: <1363897842-19835-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363897842-19835-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Thu, Mar 21, 2013 at 04:30:41PM -0400, Rhyland Klein wrote:
> The enum is missing the definition for the first bit, which makes all
> the rest off by one. Add definition for the TPS65090_IRQ_INTERRUPT bit
> which at 0.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> v4:
>  - no changes since v1
> 
>  include/linux/mfd/tps65090.h |    1 +
>  1 file changed, 1 insertion(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
