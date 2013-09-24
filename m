Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3IXWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:16:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40459 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IXWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:16:26 -0400
Message-ID: <52420F38.6030004@codeaurora.org>
Date: Tue, 24 Sep 2013 15:16:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/6] clk: exynos-audss: convert to platform device
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org> <1380046016-5811-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/13 11:06, Andrew Bresticker wrote:
> +static int __init exynos_audss_clk_init(void)
> +{
> +	return platform_driver_register(&exynos_audss_clk_driver);
> +}
> +core_initcall(exynos_audss_clk_init);
> +
> +static void __init exynos_audss_clk_exit(void)

__exit?

> +{
> +	platform_driver_unregister(&exynos_audss_clk_driver);
> +}
> +module_exit(exynos_audss_clk_exit);
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

