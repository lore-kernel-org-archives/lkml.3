Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3DWJx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:53:56 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:29503
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab3DWJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:53:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 23 Apr 2013 17:53:37 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [linuxppc-release] [PATCH v2 01/15] powerpc/85xx: cache
 operations for Freescale SoCs based on BOOK3E
Message-ID: <20130423095337.GA26010@localhost.localdomain>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar, Scott,

Do you have any comments on this set of patches?

Best Regards,
-Chenhui

On Fri, Apr 19, 2013 at 06:47:34PM +0800, Zhao Chenhui wrote:
> These cache operations support Freescale SoCs based on BOOK3E.
> Move L1 cache operations to fsl_booke_cache.S in order to maintain
> easily. And, add cache operations for backside L2 cache and platform cache.
> 
> The backside L2 cache appears on e500mc and e5500 core. The platform cache
> supported by this patch is L2 Look-Aside Cache, which appears on SoCs
> with e500v1/e500v2 core, such as MPC8572, P1020, etc.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
>  arch/powerpc/include/asm/cacheflush.h |    8 ++
>  arch/powerpc/kernel/Makefile          |    1 +
>  arch/powerpc/kernel/fsl_booke_cache.S |  210 +++++++++++++++++++++++++++++++++
>  arch/powerpc/kernel/head_fsl_booke.S  |   74 ------------
>  4 files changed, 219 insertions(+), 74 deletions(-)
>  create mode 100644 arch/powerpc/kernel/fsl_booke_cache.S
> 

