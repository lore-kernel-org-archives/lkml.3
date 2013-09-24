Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3IXIIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:08:36 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18893 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3IXIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:08:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 01:08:32 -0700
Date: Tue, 24 Sep 2013 11:08:30 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 05/12] clk: tegra: add header for common tegra clock IDs
Message-ID: <20130924080830.GI30013@tbergstrom-lnx.Nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
 <1379515331-19427-6-git-send-email-pdeschrijver@nvidia.com>
 <524082E3.8070801@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <524082E3.8070801@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 08:05:23PM +0200, Stephen Warren wrote:
> On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> > Many clocks are common between several Tegra SoCs. Define an enum to list
> > them so we can move them to separate files which can be shared between
> > SoCs. Each SoC specific file will provide an array with the common clocks
> > which are present on the SoC and their DT binding ID.
> 
> So, this enum is purely something internal to the driver, and is in no
> way related to the DT binding clock IDs, nor the HW peripheral clock
> register bits, and finally is a union of all extant clocks across all chips?
> 

Yes. Although there will still be the possibility to have clocks outside this
union for a while. At least until Tegra20 and Tegra30 are migrated as well.

Cheers,

Peter.
