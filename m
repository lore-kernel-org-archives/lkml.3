Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaF0MSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:18:38 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17755 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaF0MSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:18:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 05:08:37 -0700
Date: Fri, 27 Jun 2014 15:18:33 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] clk: tegra: Add soctherm and tsensor clocks to
 Tegra124 init table
Message-ID: <20140627121833.GQ3679@tbergstrom-lnx.Nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
 <1403856699-2140-6-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1403856699-2140-6-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:11:38AM +0200, Mikko Perttunen wrote:
> This adds the two clocks, soctherm and tsensor, to the T124 initialization table.
> They are required for soctherm-based thermal sensing.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> Peter, one more zero for TSENSOR, please :)

Ah :) I will take this into clk-tegra-3.17

Cheers,

Peter.
