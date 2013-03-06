Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3CFHw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:52:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19794 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3CFHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:52:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Mar 2013 23:52:14 -0800
Date: Wed, 6 Mar 2013 09:52:11 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REPOST PATCH 0/2] Table lookup for mux clock type
Message-ID: <20130306075211.GM27241@tbergstrom-lnx.Nvidia.com>
References: <1361545358-22721-1-git-send-email-pdeschrijver@nvidia.com>
 <51367625.2090405@wwwdotorg.org>
 <51368522.90700@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51368522.90700@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 12:52:02AM +0100, Stephen Warren wrote:
> On 03/05/2013 03:48 PM, Stephen Warren wrote:
> > On 02/22/2013 08:02 AM, Peter De Schrijver wrote:
> >> This patchset adds a table lookup feature to the mux clock type. This will
> >> be used by the forthcoming Tegra114 clock implementation. Also instead of
> >> a fixed field width, a mask is used. This is because Tegra114 has some muxes
> >> where the parent selector is spread over several bitfields. The second patch
> >> adapts the tegra periph clock implementation which uses struct clk_mux
> >> directly.
> >>
> >> --
> >>
> >> Mike,
> >>
> >> This patch is a dependency for the Tegra114 CCF implementation. Could you
> >> review it and merge on a topic branch so Stephen can pull it in to verify
> >> the integration?
> > 
> > Peter, does this repost you resolve the issue I pointed out at:
> > http://www.spinics.net/lists/arm-kernel/msg220873.html
> 
> Indeed, I just tested applying patch 1/2 and the build is broken without
> patch 2/2.
> 
> Can you either rework the patches to maintain bisectability, or squash
> the two together?

Will squash them together.

Cheers,

Peter.
