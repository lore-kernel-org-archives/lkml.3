Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaIBImb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:42:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41420 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbaIBIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:42:29 -0400
Date: Tue, 2 Sep 2014 09:42:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "naushad@samsung.com" <naushad@samsung.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "thomas.ab@samsung.com" <thomas.ab@samsung.com>
Subject: Re: [RESEND PATCH] arm64: dts: add <dt-bindings/> symlink
Message-ID: <20140902084214.GE25379@arm.com>
References: <1409629756-14304-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409629756-14304-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 04:49:16AM +0100, Pankaj Dubey wrote:
> Add symlink to include/dt-bindings from arch/arm64/boot/dts/include/ to
> match the ones in ARM architectures so that preprocessed device
> tree files can include various useful constant definitions.
> 
> See commit c58299aa8754 ("kbuild: create an "include chroot" for DT bindings")
> merged in v3.10-rc1 for details.
> 
> CC: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> 
> Resubmitting this change as now it will be required for Samsung ARM64
> based SoC.

Just include this change in the series adding a .dts that needs it -- it
doesn't really make sense in isolation (unless somebody desperately wants
this in?).

Will
