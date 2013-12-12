Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3LLWLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 17:11:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57602 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018Ab3LLWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 17:11:16 -0500
Date: Thu, 12 Dec 2013 23:11:03 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Richard Zhu <r65037@freescale.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH v2] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car
 PCI host maintainers
Message-ID: <20131212231103.3ceeb3bb@skate>
In-Reply-To: <20131212204610.GK4699@google.com>
References: <20131211183237.GI4699@google.com>
	<20131212204610.GK4699@google.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Bjorn Helgaas,

On Thu, 12 Dec 2013 13:46:10 -0700, Bjorn Helgaas wrote:
> [+cc Thomas]
> 
> On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> 
> OK, here's another try.  I'm not actually trying to nominate anybody; I
> just tried to write down the list we came up with in an earlier discussion [1].
> 
> I'd like confirmation from the following people that they approve of being
> listed here:
> 
>   Richard Zhu (IMX6)
>   Thomas Petazzoni (MVEBU)
>   Magnus Damm (R-CAR)
> 
> I think everybody else listed has already said they approve.
> 
> [1] http://lkml.kernel.org/r/CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com
> 
> 
> MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Add entries for PCI host controller drivers in drivers/pci/host/.
> 
> Signed-off-by: Mohit Kumar <mohit.kumar@st.com>		(DesignWare)
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>	(DesignWare)
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>	(R-CAR)
> Acked-by: Jason Cooper <jason@lakedaemon.net>		(MVEBU)
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> ---
>  MAINTAINERS |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8285ed4676b6..1c5dc36ec522 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6449,19 +6449,53 @@ F:	drivers/pci/
>  F:	include/linux/pci*
>  F:	arch/x86/pci/
>  
> +PCI DRIVER FOR IMX6
> +M:	Richard Zhu <r65037@freescale.com>
> +M:	Shawn Guo <shawn.guo@linaro.org>
> +L:	linux-pci@vger.kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pci/host/*imx6*
> +
> +PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
> +M:	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> +M:	Jason Cooper <jason@lakedaemon.net>
> +L:	linux-pci@vger.kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pci/host/*mvebu*

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thanks for doing this!

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
