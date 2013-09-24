Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3IXJMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:12:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4997 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3IXJMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:12:02 -0400
X-IronPort-AV: E=Sophos;i="4.90,969,1371081600"; 
   d="scan'208";a="54242423"
Message-ID: <1380013893.23688.10.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] powerpc/dts/virtex440: declare address/size-cells for
 phy device
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gernot Vormayr <gvormayr@gmail.com>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 24 Sep 2013 10:11:33 +0100
In-Reply-To: <1370257241-23923-1-git-send-email-ian.campbell@citrix.com>
References: <1370257241-23923-1-git-send-email-ian.campbell@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 12:00 +0100, Ian Campbell wrote:
> This fixes a warning:
> 
>   DTC     arch/powerpc/boot/virtex440-ml507.dtb
> Warning (reg_format): "reg" property in /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7 has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)
> Warning (avoid_default_addr_size): Relying on default #address-cells value for /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7
> Warning (avoid_default_addr_size): Relying on default #size-cells value for /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7

I still see this in v3.12-rc2. Ping?

> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Gernot Vormayr <gvormayr@gmail.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/powerpc/boot/dts/virtex440-ml507.dts |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/powerpc/boot/dts/virtex440-ml507.dts b/arch/powerpc/boot/dts/virtex440-ml507.dts
> index fc7073b..391a4e2 100644
> --- a/arch/powerpc/boot/dts/virtex440-ml507.dts
> +++ b/arch/powerpc/boot/dts/virtex440-ml507.dts
> @@ -257,6 +257,8 @@
>  			#size-cells = <1>;
>  			compatible = "xlnx,compound";
>  			ethernet@81c00000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
>  				compatible = "xlnx,xps-ll-temac-1.01.b";
>  				device_type = "network";
>  				interrupt-parent = <&xps_intc_0>;


