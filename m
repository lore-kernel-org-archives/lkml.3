Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3AVSrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:47:00 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54613 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754041Ab3AVSq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:46:56 -0500
Date: Tue, 22 Jan 2013 18:46:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Message-ID: <20130122184633.GI2153@mudshark.cambridge.arm.com>
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
 <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
 <50FEDC0B.7050604@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FEDC0B.7050604@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Tue, Jan 22, 2013 at 06:35:55PM +0000, Stephen Warren wrote:
> On 01/21/2013 10:52 PM, Hiroshi Doyu wrote:
> > Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
> 
> Will, is your for-next/perf branch stable; can I pull it into a branch
> destined for arm-soc? Background below:

I'm going to send a pull request to Russell tomorrow using my for-rmk/perf
branch, so *that* is stable. You might, however, want to wait for Russell to
push that out because it's also needed for kvm and, as such, will need to
be published anyway.

Sound ok?

Will
