Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595Ab3IDAyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:54:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5896 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761445Ab3IDAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:54:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Sep 2013 17:51:42 -0700
Subject: Re: [PATCH 4/4] clk: tegra114: table driven PMC clock init
From: Joseph Lo <josephl@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1378215105-12145-5-git-send-email-pdeschrijver@nvidia.com>
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
	 <1378215105-12145-5-git-send-email-pdeschrijver@nvidia.com>
Date: Wed, 4 Sep 2013 08:54:26 +0800
Message-ID: <1378256066.10742.1.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 21:31 +0800, Peter De Schrijver wrote:
> This patch converts the Tegra114 audio clock registration to be table driven
> like the periph clocks.
s/audio/PMC/ :)
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk-tegra114.c |   58 +++++++++++++++-----------------------
>  1 files changed, 23 insertions(+), 35 deletions(-)
> 
[snip]


