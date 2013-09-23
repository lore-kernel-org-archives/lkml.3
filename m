Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3IWSii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:38:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35333 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3IWSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:38:35 -0400
Message-ID: <52408AA7.7080003@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:38:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 12/12] clk: tegra: introduce common gen4 super clock
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-13-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-13-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:41 AM, Peter De Schrijver wrote:
> Introduce a common function which super clock initialization for Tegra114
> and beyond.

Again, I'm sure that a lot of the data tables in this patch are actually
SoC-specific, unless we expect Tegra114's pll_x (CPU PLL) to define the
max CPU frequency on all future SoCs...
