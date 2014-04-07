Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaDGO0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:26:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16286 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaDGO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:26:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Apr 2014 07:19:39 -0700
Date: Mon, 7 Apr 2014 17:26:20 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <treding@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] clk: tegra: Fix PLLE programming
Message-ID: <20140407142620.GA30476@tbergstrom-lnx.Nvidia.com>
References: <1396619715-15524-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1396619715-15524-1-git-send-email-treding@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 03:55:13PM +0200, Thierry Reding wrote:
> PLLE has M, N and P divider shift and width parameters that differ from
> the defaults. Furthermore, when clearing the M, N and P divider fields
> the corresponding masks were never shifted, thereby clearing only the
> lowest bits of the register. This lead to a situation where the PLLE
> programming would only work if the register hadn't been touched before.
> 

Will take this into tegra-clk-next. Mike, given that this is bug fix for
a feature which is supposed to work, I think it's appropriate to try to get
this into 3.15 still. I will make a pull-request on 3.15-rc1 as soon as it
appears.

Cheers,

Peter.
