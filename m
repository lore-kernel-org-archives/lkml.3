Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937109Ab3DIIXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:23:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:45103 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935711Ab3DIIXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="224938468"
Date: Tue, 9 Apr 2013 10:22:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Don't use system PM operations
Message-ID: <20130409082258.GL24058@zurbaran>
References: <1363952422-27426-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363952422-27426-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Mar 22, 2013 at 12:40:22PM +0100, Mark Brown wrote:
> For realistic systems the power management is controlled entirely via
> runtime PM - if the device is not runtime suspended then the suspend
> will abort without doing anything as functionality such as accessory
> detection or audio bypass will require the device to be enabled while
> if the device is runtime suspended it is already in the lowest power
> state. This means that system suspend is redundant and can be removed
> which avoids issues with attempting to double disable the regulators.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
