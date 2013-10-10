Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3JJP57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:57:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:34863 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3JJP54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:57:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1072,1371106800"; 
   d="scan'208";a="414953210"
Date: Thu, 10 Oct 2013 17:54:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [REPOST/PATCH] mfd: tps65910: remove warning during dt node
 parsing
Message-ID: <20131010155443.GB3942@zurbaran>
References: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, Sep 26, 2012 at 06:18:04PM +0530, Laxman Dewangan wrote:
> Driver throw the warning message if dt node does not
> have the info for VMBCH-Threshold and VMBCH2-Threshold.
> These properties are optional property and hence it
> is not mandatory to have these on DT node and in this case
> it should not throw the warning message.
> It creates noise from driver as follows:
> [    0.384605] tps65910 4-002d: VMBCH-Threshold not specified
> [    0.384616] tps65910 4-002d: VMBCH2-Threshold not specified
> 
> Removing the warning message from driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> It seems orginal patch has been lost. Reposting it.
> 
>  drivers/mfd/tps65910.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
Applied and pushed to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
