Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3HTI6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:58:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:8762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab3HTI6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="388946801"
Date: Tue, 20 Aug 2013 13:45:22 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: djbw@fb.com, leoli@freescale.com, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] DMA: Freescale: Add support for 8-channel DMA
 engine
Message-ID: <20130820081522.GC5810@intel.com>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
 <20130729105901.GI29095@intel.com>
 <521329EA.3050900@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521329EA.3050900@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:33:46PM +0800, Hongbo Zhang wrote:
> On 07/29/2013 06:59 PM, Vinod Koul wrote:
> >On Mon, Jul 29, 2013 at 06:49:01PM +0800, hongbo.zhang@freescale.com wrote:
> >>From: Hongbo Zhang <hongbo.zhang@freescale.com>
> >>
> >>Hi Vinod, Dan, Scott and Leo, please have a look at these V7 patches.
> >The dma relates changes look okay to me.
> >
> >I need someone to review and ACK the DT bindings.
> >
> >~Vinod
> Vinod,
> Are you using this tree?
> http://git.infradead.org/users/vkoul/slave-dma.git
Yes

> Did you merge these patches?
No

As I said I would like someone who know DT and dma binding to ack them. I see
devicetree ML has been cced, can Arnd or someone else review these...

~Vinod
