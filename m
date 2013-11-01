Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3KANTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:19:13 -0400
Received: from 8bytes.org ([85.214.48.195]:38124 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3KANTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:19:12 -0400
Date: Fri, 1 Nov 2013 14:19:09 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 1/2] IOMMU/trivial: Use for_each_drhd_unit() instead of
 list_for_each_entry()
Message-ID: <20131101131907.GC3348@8bytes.org>
References: <1383211516-38776-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383211516-38776-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 14:19:11 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5273aa4f20869468715180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 05:25:16PM +0800, Yijing Wang wrote:
> Use for_each_drhd_unit() instead of list_for_each_entry for
> better readability.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied both, thanks.


