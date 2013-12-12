Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3LLHAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:00:42 -0500
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:29423
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab3LLHA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:00:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1447Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 12 Dec 2013 15:00:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Richard Zhu <r65037@freescale.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Message-ID: <20131212070045.GO18380@S2101-09.ap.freescale.net>
References: <20131211183237.GI4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131211183237.GI4699@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> +PCI DRIVER FOR IMX6
> +M:	Shawn Guo <shawn.guo@linaro.org>

Thanks for the nomination.  But I think a better person for this
position would be Richard Zhu <r65037@freescale.com> (copied).  He knows
the driver and controller much better than myself, and most importantly
he is the driver owner for Freescale kernel and he has the contact to
Freescale PCIe hardware people.

Shawn

> +L:	linux-pci@vger.kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pci/host/*imx6*

