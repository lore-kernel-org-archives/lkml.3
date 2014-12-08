Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaLHEAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:00:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:44129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaLHEAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:00:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,536,1413270000"; 
   d="scan'208";a="650055816"
Message-ID: <1418011208.19126.19.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal/powerclamp: add id for braswell cpu
From: Zhang Rui <rui.zhang@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Date: Mon, 08 Dec 2014 12:00:08 +0800
In-Reply-To: <1417713466-1058-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1417713466-1058-1-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 09:17 -0800, Jacob Pan wrote:

Adding your Signed-off-by and applied.

thanks,
rui

> ---
>  drivers/thermal/intel_powerclamp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
> index 95cb7fc..b46c706 100644
> --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -689,6 +689,7 @@ static const struct x86_cpu_id intel_powerclamp_ids[] = {
>  	{ X86_VENDOR_INTEL, 6, 0x3f},
>  	{ X86_VENDOR_INTEL, 6, 0x45},
>  	{ X86_VENDOR_INTEL, 6, 0x46},
> +	{ X86_VENDOR_INTEL, 6, 0x4c},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, intel_powerclamp_ids);


