Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab3GaVEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:04:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58944 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3GaVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:04:45 -0400
Message-ID: <51F97BEA.7040006@wwwdotorg.org>
Date: Wed, 31 Jul 2013 15:04:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, pgaikwad@nvidia.com,
        pdeschrijver@nvidia.com
CC: mturquette@linaro.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] clk: tegra30: Don't wait for PLL_U lock bit
References: <1375292551-7933-1-git-send-email-ttynkkynen@nvidia.com> <1375292551-7933-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292551-7933-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
> The lock bit on PLL_U does not seem to be working correctly and
> sometimes never gets set when waiting for the PLL to come up.
> Remove the TEGRA_PLL_USE_LOCK flag to use a constant delay.

Peter, Prashant,

I think you said that the lock bits should work on Tegra30 (albeit they
don't on Tegra20)? Can you remind me if the do/don't?

If Peter and Prashant are OK with this patch, feel free to take my ack.
