Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965704Ab3FTREm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:04:42 -0400
Received: from 8bytes.org ([85.214.48.195]:35544 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965648Ab3FTREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:04:40 -0400
Date: Thu, 20 Jun 2013 19:04:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 06/12] msm: iommu: Use clk_set_rate() instead of
 clk_set_min_rate()
Message-ID: <20130620170437.GB11309@8bytes.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-7-git-send-email-sboyd@codeaurora.org>
 <20130620164142.GD6300@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620164142.GD6300@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 19:04:39 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3362720861786515334
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:41:42AM -0700, Stephen Boyd wrote:
> Sending to correct Joerg address.
> 
> On 06/17, Stephen Boyd wrote:
> > Calling clk_set_min_rate() is no better than just calling
> > clk_set_rate() because MSM clock code already takes care of
> > calling the min_rate ops if the clock really needs
> > clk_set_min_rate() called on it.
> > 
> > Cc: Joerg Roedel <joerg.roedel@amd.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Joerg Roedel <joro@8bytes.org>


