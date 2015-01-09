Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbbAIRKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:10:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60758 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbAIRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:10:23 -0500
Date: Fri, 9 Jan 2015 11:10:21 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] soc: qcom: Add TCSR driver
Message-ID: <20150109171021.GB16970@qualcomm.com>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
 <1420757577-20425-2-git-send-email-agross@codeaurora.org>
 <54AF1540.6090800@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AF1540.6090800@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:39:44PM -0800, Stephen Boyd wrote:
> On 01/08/2015 02:52 PM, Andy Gross wrote:
> > +
> > +static struct platform_driver qcom_tcsr_driver = {
> > +	.driver = {
> > +		.name		= "tcsr",
> > +		.owner		= THIS_MODULE,
> 
> This is done by the module_platform_driver() macro now so it's largely
> unnecessary. Best to remove it so that the janitors don't find you!

Old habits die hard......

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

