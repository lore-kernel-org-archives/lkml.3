Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3DEGNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:13:40 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14491
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab3DEGNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:13:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIda00hdc73hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 5 Apr 2013 14:13:25 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 0/2] cpufreq/regulator: Handle regulators that defer
 probe with device tree bindings
Message-ID: <20130405061323.GB2667@S2101-09.ap.freescale.net>
References: <1365135708-23886-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1365135708-23886-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:21:46PM -0500, Nishanth Menon wrote:
> Nishanth Menon (2):
>   regulator: core: return err value for regulator_get if there is no DT
>     binding
>   cpufreq: cpufreq-cpu0: defer probe when regulator is not ready

For both,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

