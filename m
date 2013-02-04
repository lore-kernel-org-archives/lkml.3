Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3BDV5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:57:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60628 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3BDV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:57:22 -0500
Message-ID: <51102EBD.1060507@wwwdotorg.org>
Date: Mon, 04 Feb 2013 14:57:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 01/10] clk: tegra: Refactor PLL programming code
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359713962-16822-2-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 03:18 AM, Peter De Schrijver wrote:
> Refactor the PLL programming code to make it useable by the new PLL types
> introduced by Tegra114.

I tested this series on Tegra20 and Tegra30 for regressions and found
none. Note that I didn't test on Tegra114. The series,

Tested-by: Stephen Warren <swarren@nvidia.com>

Also, I briefly reviewed the code and aside from comments that have
already been made, so the series,

Reviewed-by: Stephen Warren <swarren@nvidia.com>
