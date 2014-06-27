Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaF0MUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:20:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17793 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0MUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:20:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jun 2014 05:14:00 -0700
Date: Fri, 27 Jun 2014 15:19:54 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "Mike Turquette" <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: export clock names for debugging
Message-ID: <20140627121954.GR3679@tbergstrom-lnx.Nvidia.com>
References: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
 <53AC41B0.40307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53AC41B0.40307@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 05:52:16PM +0200, Stephen Warren wrote:
> On 06/26/2014 09:48 AM, Peter De Schrijver wrote:
> > When writing a module for testing or debugging purposes, there is no way to
> > get hold of clk handles. This patch solves this by exposing all valid clocks
> > as clkdev's for the virtual device tegra-clk-debug.
> 
> This is to support clk_get_sys()?
> 

Yes.

> I guess this seems fine, so feel free to apply it, but I slightly wonder
> why not just include this change as part of the presumably local and
> never-to-be-upstreamed test/dev module?

The idea is to allow local debug modules to get hold of the struct clk *. I
don't think that's possible without using clk_get_sys()?

Cheers,

Peter.
