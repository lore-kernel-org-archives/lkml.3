Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LLHk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:40:59 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52762 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458Ab3LLHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:40:57 -0500
Message-ID: <52A96877.90902@free-electrons.com>
Date: Thu, 12 Dec 2013 08:40:39 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
CC: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-samsung-soc@vger.kernel.org, Wei Yongjun <weiyj.lk@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Simon Horman <horms@verge.net.au>,
        linux-sh@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
References: <20131211183237.GI4699@google.com>
In-Reply-To: <20131211183237.GI4699@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn, ,

On 11/12/2013 19:32, Bjorn Helgaas wrote:
> If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> 
> Bjorn
> 
> 
> MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers
> 
> Add entries for PCI host controller drivers in drivers/pci/host/.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  MAINTAINERS |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8285ed4676b6..826c722d92ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6449,16 +6449,47 @@ F:	drivers/pci/
>  F:	include/linux/pci*
>  F:	arch/x86/pci/
>  
> +PCI DRIVER FOR DESIGNWARE
> +M:	Jingoo Han <jg1.han@samsung.com>
> +L:	linux-pci@vger.kernel.org
> +S:	Maintained
> +F:	drivers/pci/host/*designware*
> +
> +PCI DRIVER FOR IMX6
> +M:	Shawn Guo <shawn.guo@linaro.org>
> +L:	linux-pci@vger.kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pci/host/*imx6*
> +
> +PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
> +M:	Jason Cooper <jason@lakedaemon.net>
> +L:	linux-pci@vger.kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pci/host/*mvebu*

I think that Thomas Petazzoni would be more appropriate, he worked
on the mvebu PCIe since 6 moths and now know very well the
subject. Until now all the mvebu PCIe related questions were
managed by Thomas.

Regards,

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
