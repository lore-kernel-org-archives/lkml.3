Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaI2IOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:14:10 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7567 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaI2IOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:14:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 29 Sep 2014 01:13:24 -0700
Date: Mon, 29 Sep 2014 11:14:03 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <cyndis@kapsi.fi>, <edubezval@gmail.com>,
        <swarren@wwwdotorg.org>, <linux-pm@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <juha-matti.tilli@iki.fi>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v6 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140929081403.GF25537@tbergstrom-lnx.Nvidia.com>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
 <1411724593-4037-5-git-send-email-cyndis@kapsi.fi>
 <20140926114533.GN31106@ulmo> <5425CC6F.2020309@kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5425CC6F.2020309@kapsi.fi>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >>+struct tegra_tsensor_configuration {
> >>+	u32 tall, tsample, tiddq_en, ten_count;
> >>+	u32 pdiv, tsample_ate, pdiv_ate;
> >
> >What's the significance of the "ate" suffix?
> 
> Again, no idea.

I presume it's Automated Test Equipment refering to the device to test silicon
coming back from the fab.

Cheers,

Peter.
