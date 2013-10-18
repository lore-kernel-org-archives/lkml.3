Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3JRSjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:39:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3JRSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:39:30 -0400
Message-ID: <52618060.1060804@codeaurora.org>
Date: Fri, 18 Oct 2013 11:39:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
CC: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com> <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 07:11, Stanimir Varbanov wrote:
> This adds a driver for hardware random number generator present
> on Qualcomm MSM SoC's.
>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

