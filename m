Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaFCLLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:11:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:42330 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaFCLLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:11:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,964,1392192000"; 
   d="scan'208";a="541711559"
Date: Tue, 3 Jun 2014 14:10:57 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, linus.walleij@linaro.org, broonie@kernel.org,
        sameo@linux.intel.com, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v5 2/3] mfd: intel_soc_pmic: Crystal Cove support
Message-ID: <20140603111057.GI1730@lahna.fi.intel.com>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:26:03PM +0800, Zhu, Lejun wrote:
> This patch provides chip-specific support for Crystal Cove. Crystal
> Cove is the PMIC in Baytrail-T platform.
> 
> Also adds Intel SoC PMIC support to the build files.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
