Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaIEInE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:43:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39036 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756384AbaIEInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:43:00 -0400
Date: Fri, 5 Sep 2014 09:42:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v2 0/4] arm64, thunder: Enable Cavium Thunder SoC Family
Message-ID: <20140905084254.GF13515@arm.com>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409903205-2762-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 08:46:41AM +0100, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> This initial patches enable Cavium Thunder SoC Family. The patches add
> Kconfig and devicetree support and then add Thunder to the defconfig.
> 
> The Thunder system needs more enablement patches for subsystems and
> devices, this includes network, ahci, gicv3/gicv3-its, pci, smmu, kvm.
> We will send separate patch sets for these. All of them base on this
> initial patches.
> 
> I sent a separate patch set independently that introduces support for
> dts vendor subdirs. After both patch sets have been applied I will
> send a patch in addition that moves the dts file into a subdirectory.
> 
> Patches are available here:

If you can get some acks for the DT bits, I'm happy to take this via the
arm64 tree for 3.18.

Will
