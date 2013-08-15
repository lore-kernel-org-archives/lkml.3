Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3HOTbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:31:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47387 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab3HOTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:31:53 -0400
Message-ID: <520D2CAE.3090501@cogentembedded.com>
Date: Thu, 15 Aug 2013 23:31:58 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 5/5] ARM: davinci: da850: add OF_DEV_AUXDATA entry
 for eth0.
References: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com> <1376546497-26931-6-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376546497-26931-6-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-08-2013 10:01, Lad, Prabhakar wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

> Add OF_DEV_AUXDATA for eth0  driver in da850 board dt
> file to use emac clock.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
[...]

> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index d172563..caa9202 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -44,6 +44,9 @@ static struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
>   	OF_DEV_AUXDATA("ns16550a", 0x01d0c000, "serial8250.1", NULL),
>   	OF_DEV_AUXDATA("ns16550a", 0x01d0d000, "serial8250.2", NULL),
>   	OF_DEV_AUXDATA("ti,davinci_mdio", 0x01e24000, "davinci_mdio.0", NULL),
> +	OF_DEV_AUXDATA("ti,davinci-dm6467-emac", 0x01e20000, "davinci_emac.1",
> +		       NULL),
> +

    Empty line hardly needed here.

>   	{}
>   };

WBR, Sergei

