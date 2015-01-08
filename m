Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbbAHXjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 18:39:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbAHXjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:39:45 -0500
Message-ID: <54AF1540.6090800@codeaurora.org>
Date: Thu, 08 Jan 2015 15:39:44 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, linux-arm-msm@vger.kernel.org
CC: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] soc: qcom: Add TCSR driver
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org> <1420757577-20425-2-git-send-email-agross@codeaurora.org>
In-Reply-To: <1420757577-20425-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 02:52 PM, Andy Gross wrote:
> +
> +static struct platform_driver qcom_tcsr_driver = {
> +	.driver = {
> +		.name		= "tcsr",
> +		.owner		= THIS_MODULE,

This is done by the module_platform_driver() macro now so it's largely
unnecessary. Best to remove it so that the janitors don't find you!

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

