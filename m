Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaAFOqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:46:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:29585 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAFOqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:46:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="454279911"
Message-ID: <1389019601.5853.17.camel@rzhang1-mobl4>
Subject: Re: [PATCHv2 0/7] DRA7: DT thermal support
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 22:46:41 +0800
In-Reply-To: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com>
References: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 08:36 -0400, Eduardo Valentin wrote:
> Hello all,
> 
> Now that the basic thermal DT support is merged into Rui's tree,
> I am resending this series, which introduces the DT node entries
> for DRA7 thermal limits representation.
> 
> The series adds two thermal zones, to represent IVA and DSPEVE,
> respectively. It also adds the support to tmp102 and a corresponding
> pcb thermal zone.
> 
> There are only cosmetic changes from v1. A couple of spaces and tabulations
> have been fixed, and minor changes in sentences present in commit log.
> One difference from V1 is the fact that now bandgap is introduced under
> OCP, which is also a minor diff.
> 
> This patch series has been runtime tested on DRA7-evm.
> 
> All best
> 
> Eduardo Valentin (7):
>   arm: dts: add dra7 DSPEVE thermal data
>   arm: dts: add dra7 IVA thermal data
>   arm: dts: dra7: add bandgap entry
>   arm: dts: add cooling properties on dra7 cpu node
>   arm: dts: dra7: add thermal data
>   arm: dts: add tmp102 i2c sensor node on dra7-evm
>   arm: dts: add thermal zones info on tmp102 for DRA7-EVM
> 
>  arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7-evm.dts             | 22 ++++++++++++++++++++++
>  arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7.dtsi                | 26 ++++++++++++++++++++++++++

I'm okay with this patch set. But as long as this patch set does not
change any code under drivers/thermal/, I prefer these patches to go to
your thermal-soc tree first.

thanks,
rui
>  4 files changed, 104 insertions(+)
>  create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi
> 


