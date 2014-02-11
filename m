Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaBKGfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:35:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56701 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKGfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:35:47 -0500
Date: Mon, 10 Feb 2014 22:35:46 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 0/7] Modernize pm8921 with irqdomains, regmap, DT
Message-ID: <20140211063546.GF10784@codeaurora.org>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Stephen Boyd wrote:
> These patches lay the groundwork for converting the pm8921 sub-devices
> to devicetree as well as simplify the API by migrating the core code
> to use the regmap API instead of the custom pm8xxx read/write wrapper.

Lee,

Can you pick up these patches now? I don't think we're going to
get an ack from the DT reviewers. Its been over a month and
according to the documentation[1] I think we've done our due
diligence.

[1] Documentation/devicetree/bindings/submitting-patches.txt

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
