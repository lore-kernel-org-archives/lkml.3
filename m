Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab3DHQB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:01:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:24580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935076Ab3DHQBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="319177775"
Date: Mon, 8 Apr 2013 18:01:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [Patch V4 2/2] mfd: tps65090: Add resources for charger
Message-ID: <20130408160138.GA24058@zurbaran>
References: <1363897842-19835-1-git-send-email-rklein@nvidia.com>
 <1363897842-19835-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363897842-19835-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Thu, Mar 21, 2013 at 04:30:42PM -0400, Rhyland Klein wrote:
> Add irq resources to pass to the charger mfd sub dev so
> the charger can listen for interrupts.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> v4:
>  - Added of_compatible string to resources for tps65090-charger
> v3:
>  - no changes since v2
> v2:
>  - no changes since v1
> 
>  drivers/mfd/tps65090.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
