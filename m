Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbbAELkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:40:47 -0500
Received: from 8bytes.org ([81.169.241.247]:58380 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbbAELkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:40:45 -0500
Date: Mon, 5 Jan 2015 12:40:43 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] iommu: Fix build of allmod/allyes config on ARMv8
 architecture
Message-ID: <20150105114043.GA13975@8bytes.org>
References: <1417787257-10056-1-git-send-email-k.kozlowski@samsung.com>
 <20150105110347.GB19590@8bytes.org>
 <1420456143.31776.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420456143.31776.3.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:09:03PM +0100, Krzysztof Kozlowski wrote:
> Thanks, but... Few days after my patch Mark Brown posted something
> similar:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310743.html
> 
> It was merged by Arnd Bergman and sent to Linus around 3.19-rc1. It is
> merged in mainline now:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=20911ce6078fd1503dbf73f761316c66738bf83b
> 
> ... so my patch can be dropped.

Okay, thanks. Patch is dropped.

