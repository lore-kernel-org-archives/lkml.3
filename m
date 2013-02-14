Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934922Ab3BNUef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:34:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7857 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab3BNUee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:34:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 12:30:30 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sjg@chromium.org" <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 14 Feb 2013 21:34:22 +0100
Subject: Re: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
Thread-Topic: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
Thread-Index: Ac4K8q1tpDus8qs7Rmyk8UnDmzo5Tw==
Message-ID: <20130214.223422.1106350409475384652.hdoyu@nvidia.com>
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com><1360868369-20093-2-git-send-email-hdoyu@nvidia.com><511D45E0.1080105@wwwdotorg.org>
In-Reply-To: <511D45E0.1080105@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Thu, 14 Feb 2013 21:15:28 +0100:

> Oh, and I don't think you updated e.g. nvidia,tegra20-car.txt to remove
> the list of clocks.

Not yet removed. I think that this could be done with the patch which
allows kernel source to include DT header files.

> BTW, I assume this patch includes the changes from my recent "clk:
> tegra: fix driver to match DT binding" and anything else similar that's
> in the most recent Tegra for-next?

Of course not, that's a little bit too recent.

I'll rerun my script against the laste Tegra for-next and post them as
v3(inc. Tegra114)
