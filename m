Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3I0KvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:51:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44018 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117Ab3I0KvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:51:04 -0400
Date: Fri, 27 Sep 2013 11:50:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v1 0/7] enable FPSIMD lazy save and restore for arm64
Message-ID: <20130927105045.GA11063@MacBook-Pro.local>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:04:40AM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> This patchset enables FPSIMD lazy save and restore for ARM64, you could
> apply it against v3.12-rc2.
> 
> We have done basic functional tests on ARM fast model, but still lack
> of detail performance benchmark on real hardware platforms. We would
> appreciate if you could help to test it on really hardware platforms!

That's my issue as well, I would like to see some benchmarks before
merging such patches.

-- 
Catalin
