Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3BVG4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:56:10 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43374
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3BVG4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:56:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275dh6d523h5e7bkz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
Date: Fri, 22 Feb 2013 14:55:53 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222065548.GA3252@b29396-Latitude-E6410>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 07:29:02PM +0400, Alexander Shiyan wrote:
> This patch allow using syscon driver from the platform data, i.e.
> possibility using driver on systems without oftree support.
> For search syscon device from the client drivers,
> "syscon_regmap_lookup_by_pdevname" function was added.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

[...]

> +	syscon->base = devm_ioremap_resource(dev, res);
> +	if (!syscon->base)

Is this correct?

> +		return -EBUSY;
>

Otherwise, i'm also ok with this patch.
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

BTW, i did not see Samuel's tree having this new API.
So, who will pick this patch?

Regards
Dong Aisheng

