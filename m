Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3JaQAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:00:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33736 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab3JaQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:00:13 -0400
Date: Thu, 31 Oct 2013 15:59:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/5] iommu/arm-smmu: Use devm_ioremap_resource
Message-ID: <20131031155933.GA30623@mudshark.cambridge.arm.com>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
 <1383217687-12037-4-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383217687-12037-4-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 11:08:05AM +0000, Tushar Behera wrote:
> While at it, propagate the error code.

Thanks, but I already have an equivalent patch queued which Joerg is going
to pull real soon now (right, Joerg? :p).

Will
