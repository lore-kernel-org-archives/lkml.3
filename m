Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab3CISCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:02:21 -0500
Received: from 8bytes.org ([85.214.48.195]:50944 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab3CISCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:02:20 -0500
Date: Sat, 9 Mar 2013 19:02:14 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, iommu@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: Re: [PATCH 8/9] iommu: OMAP: build only on OMAP2+
Message-ID: <20130309180213.GA4876@8bytes.org>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-9-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362521809-22989-9-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Mar  9 19:02:18 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 513b792a23671668575250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 11:16:48PM +0100, Arnd Bergmann wrote:
> The OMAP IOMMU driver intentionally fails to build on OMAP1
> platforms, so we should not allow enabling it there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: iommu@lists.linux-foundation.org
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Omar Ramirez Luna <omar.luna@linaro.org>

Applied to iommu/fixes, thanks Arnd.


