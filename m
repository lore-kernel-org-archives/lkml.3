Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038Ab3DCSKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:10:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762949Ab3DCSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:10:16 -0400
Message-ID: <515C7083.9070702@wwwdotorg.org>
Date: Wed, 03 Apr 2013 12:10:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 12/14] clk: tegra: devicetree match for nvidia,tegra114-car
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com> <1365000110-8916-13-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1365000110-8916-13-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:40 AM, Peter De Schrijver wrote:
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

I see this patch does depend on my "clk: tegra: defer application of
init table", although my patch was based on top of this series so needs
to be adjusted to remove the Tegra114 portions so it can be applied first.
