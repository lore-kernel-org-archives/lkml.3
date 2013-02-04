Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3BDVRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:17:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43077 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3BDVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:17:40 -0500
Message-ID: <5110253C.3070005@wwwdotorg.org>
Date: Mon, 04 Feb 2013 14:16:44 -0700
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
Subject: Re: [PATCH v5 07/10] ARM: tegra: Define Tegra114 CAR binding
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-8-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359713962-16822-8-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 03:18 AM, Peter De Schrijver wrote:
> The device tree binding models Tegra114 CAR (Clock And Reset) as a single
> monolithic clock provider.
...
> +- #clock-cells : Should be 1.
> +  In clock consumers, this cell represents the clock ID exposed by the CAR.
...
> +  222	pll_u
> +  223	pll_u_480M
> +  224	pll_u_60M
> +  225	pll_u_48M
> +  226	pll_u_12M

I notice here that we have separate clock IDs for the various PLL u
outputs. We don't have this on Tegra20 or Tegra30, but I wonder if we
should have them there too?
