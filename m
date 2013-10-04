Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3JDPwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:52:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8530 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3JDPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:52:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 08:48:43 -0700
Date: Fri, 4 Oct 2013 18:52:36 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, "Paul Walmsley" <pwalmsley@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: replace enum tegra114_clk by binding header
Message-ID: <20131004155236.GX3973@tbergstrom-lnx.Nvidia.com>
References: <1378213915-10222-1-git-send-email-pdeschrijver@nvidia.com>
 <522622F1.70008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <522622F1.70008@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 07:57:05PM +0200, Stephen Warren wrote:
> On 09/03/2013 07:11 AM, Peter De Schrijver wrote:
> > As the clock IDs are now specified in a header file, we can use those
> > definitions instead of maintaining an internal enum.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> I assume this will go through Mike's clock tree for 3.13.
> 

Mike?

> I assume similar patches will follow for Tegra20/30?

Yes.
