Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbaEFNq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:46:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55410 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbaEFNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:46:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+HXGer1eOUZP8SMXVkioHzfJMFIU6NL3Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 93A9C56D10F
Date: Tue, 6 May 2014 09:46:40 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 12/20] ARM: configs: Add usb_xhci_mvebu to
 multi_v7_defconfig
Message-ID: <20140506134640.GW28159@titan.lakedaemon.net>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-13-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399335255-589-13-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you need to do another respin of this series, please add Olof, Arnd
and Kevin (and arm@kernel.org) to the To:.  Otherwise, I'll take care of
it.

thx,

Jason.

On Tue, May 06, 2014 at 02:14:07AM +0200, Gregory CLEMENT wrote:
> The Marvell Armada 38x platform needs the xhci_mvebu driver enabled
> for the xHCI USB hosts, so this commit enables the corresponding
> Kconfig option in multi_v7_defconfig.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index d4e8a47a2f7c..820cc35d40cf 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -254,6 +254,7 @@ CONFIG_SND_SOC_TEGRA_ALC5632=y
>  CONFIG_SND_SOC_TEGRA_MAX98090=y
>  CONFIG_USB=y
>  CONFIG_USB_XHCI_HCD=y
> +CONFIG_USB_XHCI_MVEBU=y
>  CONFIG_USB_EHCI_HCD=y
>  CONFIG_USB_EHCI_TEGRA=y
>  CONFIG_USB_EHCI_HCD_PLATFORM=y
> -- 
> 1.8.1.2
> 
