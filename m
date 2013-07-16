Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3GPBhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:37:34 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:42848
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab3GPBhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:37:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zcb8k551biz98dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 16 Jul 2013 09:22:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: <Sudeep.KarkadaNagesha@arm.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cpufreq@vger.kernel.org>,
        <arnd@arndb.de>, <olof@lixom.net>, <lorenzo.pieralisi@arm.com>,
        <rob.herring@calxeda.com>, <grant.likely@linaro.org>, <rjw@sisk.pl>,
        <viresh.kumar@linaro.org>, <gregkh@linuxfoundation.org>,
        <gregory.clement@free-electrons.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 06/11] cpufreq: imx6q-cpufreq: remove device tree
 parsing for cpu nodes
Message-ID: <20130716012209.GA28375@S2101-09.ap.freescale.net>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1373883732-26303-7-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1373883732-26303-7-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:22:07AM +0100, Sudeep.KarkadaNagesha@arm.com wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Now that the cpu device registration initialises the of_node(if available)
> appropriately for all the cpus, parsing here is redundant.
> 
> This patch removes all DT parsing and uses cpu->of_node instead.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  arch/arm/mach-imx/mach-imx6q.c  | 3 +--
>  drivers/cpufreq/imx6q-cpufreq.c | 4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)

