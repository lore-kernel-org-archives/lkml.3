Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3KXKiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:38:17 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27428
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab3KXKiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:38:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579eh551biz98dI154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h1155h)
Date: Sun, 24 Nov 2013 18:12:06 +0800
From: Peter Chen <peter.chen@freescale.com>
To: <dt.tangr@gmail.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>
Subject: Re: [PATCHv2] usb: chipidea: add support for USB OTG controller on
 TI-NSPIRE
Message-ID: <20131124101205.GA30724@shlinux1.ap.freescale.net>
References: <1385278667-91856-1-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1385278667-91856-1-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 06:37:47PM +1100, dt.tangr@gmail.com wrote:
> From: Daniel Tang <dt.tangr@gmail.com>
> 
> Changelog v2:
>  * Rename ci13xxx to ci_hdrc
>  * Fixed alignment issues
> 
> The USB controller in TI-NSPIRE calculators are based off either Freescale's
> USB OTG controller or the USB controller found in the IMX233, both of which
> are Chipidea compatible.
> 
> This patch adds a device tree binding for the controller.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---

Please put the "Changelog v2" here, the change log should
not be in commit log, it is for review purpose.

> +};
> +
> +MODULE_DEVICE_TABLE(of, ci_hdrc_nspire_dt_ids);
> +module_platform_driver(ci_hdrc_nspire_driver);
> +
> +MODULE_ALIAS("platform:nspire_usb");
> +MODULE_ALIAS("platform:ci_hdrc_nspire");

Just curious, why you need to two alias?

-- 

Best Regards,
Peter Chen

