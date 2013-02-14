Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148Ab3BNKMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5802 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab3BNKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 02:08:26 -0800
Date: Thu, 14 Feb 2013 12:12:20 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: dt: add header to define tegra20 clocks
Message-ID: <20130214101220.GI3073@tbergstrom-lnx.Nvidia.com>
References: <1360791198-29462-1-git-send-email-swarren@wwwdotorg.org>
 <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:38:17AM +0100, Hiroshi Doyu wrote:
> To replace magic number in "clocks = <&tegra_car 28>;"
> 

But then we should probably also remove the enum tegra20_clk and replace it
with this header file. We should also consider removing the list of IDs from
the documentation and refer to the header file instead. Otherwise we will have
3 places which define the same IDs and we need to be sure they stay in sync...

Cheers,

Peter.
