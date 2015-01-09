Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbbAIROB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:14:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33084 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbAIRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:13:59 -0500
Date: Fri, 9 Jan 2015 11:13:56 -0600
From: Andy Gross <agross@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 1/2] soc: qcom: Add TCSR driver
Message-ID: <20150109171356.GC16970@qualcomm.com>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
 <1420757577-20425-2-git-send-email-agross@codeaurora.org>
 <4757751.7cLGsvPiZX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4757751.7cLGsvPiZX@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 01:06:56AM +0100, Arnd Bergmann wrote:
> On Thursday 08 January 2015 16:52:56 Andy Gross wrote:
> > This patch adds support for the TCSR (Top Control and Status Register) IP block
> > that is present in the Qualcomm IPQ8064, APQ8064, and some later processors.
> > This block contains additional configuration and mux settings for various
> > peripherals in the system, including the ADM DMA block and USB controller.
> > 
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > 
> 
> It sounds like this is a collection of random registers. Have you considered
> making it a syscon node instead?

That's a capital idea and solves my probe_defer issue more cleanly.  I'll rework
and resend.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

