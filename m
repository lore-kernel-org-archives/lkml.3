Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111Ab3DHJ6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:58:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:63091 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936102Ab3DHJ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="318960172"
Date: Mon, 8 Apr 2013 11:57:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: wm8994: silence bogus warning in
 wm8994_device_init()
Message-ID: <20130408095754.GQ24058@zurbaran>
References: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
 <20130219121801.GB23508@opensource.wolfsonmicro.com>
 <007101ce0f15$7a726410$6f572c30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007101ce0f15$7a726410$6f572c30$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Wed, Feb 20, 2013 at 11:53:36AM +0900, Jingoo Han wrote:
> 'patch_regs' cannot be used uninitialized in wm8994_device_init(),
> because 'patch_regs' was already guarded by 'regmap_patch'.
> Thus, that's a bogus warning.
> 
> Without this patch, the build warning happens as below:
> 
> drivers/mfd/wm8994-core.c: In function 'wm8994_i2c_probe':
> drivers/mfd/wm8994-core.c:595:7: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]
> drivers/mfd/wm8994-core.c:408:14: note: 'patch_regs' was declared here
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/wm8994-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
