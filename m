Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3IXMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:41:42 -0400
Received: from 8bytes.org ([85.214.48.195]:45393 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3IXMll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:41:41 -0400
Date: Tue, 24 Sep 2013 14:41:35 +0200
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "'David Brown'" <davidb@codeaurora.org>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Suman Anna'" <s-anna@ti.com>
Subject: Re: [PATCH] iommu: remove unnecessary platform_set_drvdata()
Message-ID: <20130924124131.GA5150@8bytes.org>
References: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 14:41:39 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5241888320861503213659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:53:01AM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.

Please split that into two patches, one for msm and one for omap so that
I can put them into their respective topic-branches. Also add the
Acked-by while you are at it, please.

Thanks,

	Joerg


