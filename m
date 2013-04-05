Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161978Ab3DEQJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:09:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:26332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161930Ab3DEQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="314198965"
Date: Fri, 5 Apr 2013 18:09:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: ab3100-otp: use module_platform_driver_probe()
Message-ID: <20130405160920.GL17363@zurbaran>
References: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Tue, Mar 05, 2013 at 01:47:06PM +0900, Jingoo Han wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ab3100-otp.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
All 3 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
