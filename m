Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaEMWJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:09:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58457 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaEMWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:08:47 -0400
Date: Tue, 13 May 2014 15:08:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 4/4] spi: qup: Add support for v1.1.1
Message-ID: <20140513220845.GH20486@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
 <1400016884-9568-5-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400016884-9568-5-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Andy Gross wrote:
> @@ -488,7 +491,7 @@ static int spi_qup_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	struct device *dev;
>  	void __iomem *base;
> -	u32 data, max_freq, iomode;
> +	u32 data = 0, max_freq, iomode;

It looks like data is unused? But actually it's used to print a
version out and now it will always print version 0. Perhaps that
printk needs an update?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
