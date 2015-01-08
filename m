Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbbAHRTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:19:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbAHRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:19:48 -0500
Date: Thu, 8 Jan 2015 11:19:46 -0600
From: Andy Gross <agross@codeaurora.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 2/2] dt/bindings: qcom_adm: Fix channel specificers
Message-ID: <20150108171946.GA15842@qualcomm.com>
References: <1420687572-7116-1-git-send-email-agross@codeaurora.org>
 <1420687572-7116-3-git-send-email-agross@codeaurora.org>
 <54AEAFB6.9050609@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AEAFB6.9050609@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 11:26:30AM -0500, Christopher Covington wrote:

<snip>

> > +DMA clients must use the format descripted in the dma.txt file, using a two
> >  cell specifier for each channel.
> >  
> >  Each dmas request consists of 3 cells:
> 
> Now 2 cells?

Good catch.  I'll fix in next rev.  Thanks!

> >   1. phandle pointing to the DMA controller
> >   2. channel number
> > - 3. CRCI assignment, if applicable.  If no CRCI flow control is required, use 0.
> > -    The CRCI is used for flow control.  It identifies the peripheral device that
> > -    is the source/destination for the transferred data.
> >  

<snip>

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

