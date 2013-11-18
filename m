Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3KRRLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:11:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43108 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3KRRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:10:56 -0500
Date: Mon, 18 Nov 2013 17:10:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131118171023.GH16735@n2100.arm.linux.org.uk>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com> <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com> <52898417.80601@nvidia.com> <20131118115842.GE4050@arm.com> <528A4869.2020701@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A4869.2020701@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:03:37AM -0700, Stephen Warren wrote:
> On 11/18/2013 04:58 AM, Catalin Marinas wrote:
> ...
> > Of course, trusted foundations interface could be plugged into cpu_ops
> > on arm64 but I will NAK it on the grounds of not using the PSCI API, nor
> > the SMC calling convention (and it's easy to fix when porting to ARMv8).
> > If a supported standard API is used, then there is no need for
> > additional code in the kernel.
> 
> What happens when someone takes an existing working secure-mode SW stack
> and simply re-uses it on some new ARMv8 SoC. Are you going to force
> people working on upstream to re-write the secure mode firmware in
> shipped hardware before allowing upstream kernel support?

I'll tell you what will happen.  They'll say "screw mainline, we're doing
our own thing".  Vendors have been doing that for years, this will be no
different and require no additional effort from them.
