Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3GOOpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:45:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:45609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab3GOOpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:45:16 -0400
Subject: Re: [PATCH V2 1/2] DMA: Freescale: Add new 8-channel DMA engine device tree nodes
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com>
Date: Mon, 15 Jul 2013 08:31:53 -0500
Cc: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <vakul@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2E51FB91-1C34-4911-AF77-F68D292F8DDC@kernel.crashing.org>
References: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com> <1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com>
To: "<hongbo.zhang@freescale.com>" <hongbo.zhang@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 5, 2013, at 1:27 AM, <hongbo.zhang@freescale.com> <hongbo.zhang@freescale.com> wrote:

> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch add
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
> arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi   |   90 +++++++++++++++++++++++++++
> arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi   |   90 +++++++++++++++++++++++++++
> arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
> 3 files changed, 182 insertions(+), 2 deletions(-)
> create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
> create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi

Why didn't you update b4si-post.dtsi as well?

- k