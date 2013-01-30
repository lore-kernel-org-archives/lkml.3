Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3A3GF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:05:27 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:16651
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab3A3GFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:05:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 30 Jan 2013 14:34:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: linux-pm <linux-pm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCH 0/2] PM / OPP : export symbol consolidation
Message-ID: <20130130063420.GA24697@S2100-06.ap.freescale.net>
References: <1359397576-26131-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359397576-26131-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:26:14PM -0600, Nishanth Menon wrote:
> Hi,
> This is a consolidation of Rafael's request for usage of EXPORT_SYMBOL_GPL
> and requirement for cpufreq helpers to be exported to be used by cpufreq
> drivers which may be modules.
> 
> https://patchwork.kernel.org/patch/1847261/ is patch #2 in this series.
> 
> Mark Langsdorf (1):
>   PM / OPP: Export more symbols for module usage
> 
> Nishanth Menon (1):
>   PM / OPP: switch exported symbols to GPL variant
> 
The series is needed by cpufreq-cpu0 and imx6q-cpufreq module build.
So, for both patches,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

