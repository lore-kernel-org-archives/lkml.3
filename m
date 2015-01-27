Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbbA0RbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:31:16 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19737 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682AbbA0RbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:31:14 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Tue, 27 Jan 2015 09:31:08 -0800
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Joonwoo Park <joonwoop@codeaurora.org>
Subject: Re: [PATCH 3/3] pinctrl: qcom: Add msm8916 pinctrl driver
Message-ID: <20150127173107.GE11960@sonymobile.com>
References: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
 <1421745476-6276-4-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1421745476-6276-4-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20 Jan 01:17 PST 2015, Stanimir Varbanov wrote:

> From: Joonwoo Park <joonwoop@codeaurora.org>
> 
> Add initial pinctrl driver to support pin configuration with
> pinctrl framework for msm8916.
> 
> Signed-off-by: Joonwoo Park <joonwoop@codeaurora.org>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
[..]
> +
> +static const struct msm_pingroup msm8916_groups[] = {
> +       PINGROUP(0, blsp_spi1, blsp_uart1, blsp_uim1, dmic0_clk, NA, NA, NA, NA,
> +                NA),

It's totally okay not to line break these things...

> +       PINGROUP(1, blsp_spi1, blsp_uart1, blsp_uim1, dmic0_data, NA, NA, NA,
> +                NA, NA),
> +       PINGROUP(2, blsp_spi1, blsp_uart1, blsp_i2c1, NA, NA, NA, NA, NA, NA),
[..]
> +};
> +
[..]

My documentation is lacking the pingroup table, the rest is:
Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
