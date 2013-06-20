Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161246Ab3FTREG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:04:06 -0400
Received: from 8bytes.org ([85.214.48.195]:35528 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161061Ab3FTREF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:04:05 -0400
Date: Thu, 20 Jun 2013 19:04:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 05/12] msm: iommu: Convert to clk_prepare/unprepare
Message-ID: <20130620170401.GA11309@8bytes.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-6-git-send-email-sboyd@codeaurora.org>
 <20130620164051.GC6300@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620164051.GC6300@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 19:04:02 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3360220861716750072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:40:51AM -0700, Stephen Boyd wrote:
> Sending to correct Joerg address.
> 
> On 06/17, Stephen Boyd wrote:
> > Add calls to clk_prepare and unprepare so that MSM can migrate to
> > the common clock framework. We never unprepare the clocks until
> > driver remove because the clocks are enabled and disabled in irq
> > context. Finer grained power management is possible in the future
> > via runtime power management techniques.
> > 
> > Cc: Joerg Roedel <joerg.roedel@amd.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Joerg Roedel <joro@8bytes.org>


