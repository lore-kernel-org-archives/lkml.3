Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaEMWUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:20:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59141 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaEMWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:20:24 -0400
Date: Tue, 13 May 2014 17:20:22 -0500
From: Andy Gross <agross@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 4/4] spi: qup: Add support for v1.1.1
Message-ID: <20140513222022.GA28128@qualcomm.com>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
 <1400016884-9568-5-git-send-email-agross@codeaurora.org>
 <20140513220845.GH20486@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513220845.GH20486@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:08:45PM -0700, Stephen Boyd wrote:
> On 05/13, Andy Gross wrote:
> > @@ -488,7 +491,7 @@ static int spi_qup_probe(struct platform_device *pdev)
> >  	struct resource *res;
> >  	struct device *dev;
> >  	void __iomem *base;
> > -	u32 data, max_freq, iomode;
> > +	u32 data = 0, max_freq, iomode;
> 
> It looks like data is unused? But actually it's used to print a
> version out and now it will always print version 0. Perhaps that
> printk needs an update?

ACK!  I thought I killed that.  I'll fix that.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
