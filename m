Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3EPWQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:16:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:36003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab3EPWQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="242695506"
Date: Fri, 17 May 2013 00:16:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 1/8] mfd: intel_msic: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130516221645.GS22822@zurbaran>
References: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Mon, May 06, 2013 at 01:04:25PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/intel_msic.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
All 8 patches applied to mfd-next.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
