Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3EXPaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:30:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60755 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3EXPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:30:12 -0400
Message-ID: <519F877F.3050801@wwwdotorg.org>
Date: Fri, 24 May 2013 09:30:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] ARM: tegra114: correctly output clk_32k
References: <1369379407-12764-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1369379407-12764-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 01:10 AM, Alexandre Courbot wrote:
> Tegra has a blink timer register that allows to modulate the
> clk_32k clock before outputting it. Since clk_32k is presented to the
> kernel as a fixed clock, make sure this register does not tamper with
> the clock frequency and that clk_32k is outputted as-is, similarly to
> what is done on t20 and t30.

drivers/clk changes should go to Mike Turquette now that there aren't
any inter-dependencies between core Tegra and Tegra clk driver patches.

I CC'd him here, but perhaps he'll want this resent if he doesn't have
the original email still.

Acked-by: Stephen Warren <swarren@nvidia.com>
