Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaFCLIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:08:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:51623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaFCLIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,964,1392192000"; 
   d="scan'208";a="521950531"
Date: Tue, 3 Jun 2014 14:08:43 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, linus.walleij@linaro.org, broonie@kernel.org,
        sameo@linux.intel.com, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v5 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140603110843.GH1730@lahna.fi.intel.com>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:26:02PM +0800, Zhu, Lejun wrote:
> This patch provides the common I2C driver code for Intel SoC PMICs.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>

Looks good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
