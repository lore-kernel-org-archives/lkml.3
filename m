Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAMQIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:08:45 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12325 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaAMQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:08:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Jan 2014 08:08:27 -0800
Date: Mon, 13 Jan 2014 18:08:35 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/7] misc Tegra clock fixes
Message-ID: <20140113160835.GE26588@tbergstrom-lnx.Nvidia.com>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
 <CAL1qeaG0Y4__viWsZeoFdf8XFN3Wk7CO2abeEjzRZg+wNRV56w@mail.gmail.com>
 <52CDD3FE.1070404@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52CDD3FE.1070404@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:41:02PM +0100, Stephen Warren wrote:
> On 01/08/2014 03:28 PM, Andrew Bresticker wrote:
> > Hi Stephen, Peter,
> > 
> >> Fixes for various clock-related issues found during bringup of
> >> Tegra124-based Venice2 and Norrin boards.
> ...
> > Any comments on this series?
> 
> Peter owns drivers/clk/tegra/, so I assume he'll handle these patches. I
> briefly looked at them when they were posted and didn't see any issues.
> 

Yes. I will... I'm still waiting for the existing pull request to show up though...
