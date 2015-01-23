Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbbAWSKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:10:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42234 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbAWSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:10:53 -0500
Date: Fri, 23 Jan 2015 18:10:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Will Deacon <Will.Deacon@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Brown <broonie@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Resend Patch v4 03/16] smp, ARM64: Kill SMP single function
 call interrupt
Message-ID: <20150123181041.GH9557@e104818-lin.cambridge.arm.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
 <1421991416-20297-4-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421991416-20297-4-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:36:42AM +0000, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

I queued the arm64 patch for 3.20. Thanks.

-- 
Catalin
