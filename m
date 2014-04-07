Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaDGWW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:22:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaDGWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:22:24 -0400
Date: Mon, 7 Apr 2014 15:22:22 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] spi: qup: Depend on ARCH_QCOM
Message-ID: <20140407222222.GJ9985@codeaurora.org>
References: <1396784733.30640.25.camel@x220>
 <20140407130853.GG14763@sirena.org.uk>
 <1396880145.12738.6.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396880145.12738.6.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Paul Bolle wrote:
> Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
> multiplatform") removed Kconfig symbol ARCH_MSM_DT. But that commit
> left one (optional) dependency on ARCH_MSM_DT untouched.
> 
> Three Kconfig symbols used to depend on ARCH_MSM_DT: ARCH_MSM8X60,
> ARCH_MSM8960, and ARCH_MSM8974. These three symbols now depend on
> ARCH_QCOM. So it appears this driver needs to depend on ARCH_QCOM too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> Resending, because Mark suggested to include the Qualcomm people (who
> know what's going on with these symbols).
> 
> Still untested!
> 
> Note that this is basically guesswork: looking at commit 8fc1b0f87d9f it
> appears to make sense to pick ARCH_QCOM here.

That's correct.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
