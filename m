Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbAVVsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:48:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbbAVVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:48:54 -0500
Date: Thu, 22 Jan 2015 15:48:51 -0600
From: Andy Gross <agross@codeaurora.org>
To: Archit Taneja <architt@codeaurora.org>
Cc: vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, svarbanov@mm-sol.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add support for BAM v1.7.0
Message-ID: <20150122214851.GA8159@qualcomm.com>
References: <1421910266-8573-1-git-send-email-architt@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421910266-8573-1-git-send-email-architt@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:34:26PM +0530, Archit Taneja wrote:
> Add register offset table entry for the newer (v1.7.0) version of the BAM IP
> found on MSM8916. Update the DT bindings documentation.
> 
> Signed-off-by: Archit Taneja <architt@codeaurora.org>
> ---

Looks good.

Reviewed-by: Andy Gross <agross@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

