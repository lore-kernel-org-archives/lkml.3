Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaKTKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:54:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55612 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaKTKyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:54:15 -0500
Date: Thu, 20 Nov 2014 10:54:11 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/2] arm64: Add support for Juno development board
Message-ID: <20141120105410.GD17214@e106497-lin.cambridge.arm.com>
References: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
In-Reply-To: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 20 Nov 2014 10:54:12.0274 (UTC) FILETIME=[518DB120:01D004B0]
X-MC-Unique: 114112010541301401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:32:09PM +0000, Liviu Dudau wrote:
> Hi,
> 
> This patchset adds device tree support for ARM's AArch64 Juno development
> board. It enables use of various peripherals on the board, from USB and
> networking to I2C and PL011 UART.
> 
> The patches can also be found in the repository at:
> 
>    git://github.com/ARM-software/linux.git juno/dts-for-armsoc
> 
> for you to fetch.

Gentle ping!

Olof, Arnd, Kevin: are you OK with this patchset?

Best regards,
Liviu

> 
> 
> Changes vs v2:
>   - rebased on top of arm-soc/next/cleanup
>   - Split the flat device tree into several files. Although some
>     commonality still remains in the main .dts file with other
>     devices trees (see psci node) it is not clear what benefits can
>     be gained from moving such a small node into its own file.
>   - Ordered nodes according to their address space
>   - Removed ulpi_phy node as it was redundant and the bindings non-standard.
> 
> v2 version: http://lkml.org/lkml/2014/11/10/242
> 
> Best regards,
> Liviu
> 
> Liviu Dudau (2):
>   arm64: Create link to include/dt-bindings to enable C preprocessor
>     use.
>   arm64: Add Juno board device tree.
> 
>  arch/arm64/boot/dts/arm/Makefile              |   1 +
>  arch/arm64/boot/dts/arm/juno-clocks.dtsi      |  45 ++++++
>  arch/arm64/boot/dts/arm/juno-motherboard.dtsi | 129 +++++++++++++++
>  arch/arm64/boot/dts/arm/juno.dts              | 218 ++++++++++++++++++++++++++
>  arch/arm64/boot/dts/include/dt-bindings       |   1 +
>  5 files changed, 394 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
>  create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
>  create mode 100644 arch/arm64/boot/dts/arm/juno.dts
>  create mode 120000 arch/arm64/boot/dts/include/dt-bindings
> 
> -- 
> 2.1.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

