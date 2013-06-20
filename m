Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624Ab3FTCym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:54:42 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:39335
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935534Ab3FTCyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:54:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 20 Jun 2013 10:52:28 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>,
        <dave.martin@arm.com>
Subject: Re: [PATCH 07/13] cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in
 error cases
Message-ID: <20130620025227.GC19896@S2101-09.ap.freescale.net>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
 <ca85a6fad679b2e305a21893811474f5802f837e.1371630975.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca85a6fad679b2e305a21893811474f5802f837e.1371630975.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:23:01PM +0530, Viresh Kumar wrote:
> PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
> should be called or both shouldn't be.
> 
> In case we have started PRECHANGE notifier and found an error, we must call
> POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
> calling notifiers is complete.
> 
> This patch fixes it.
> 
> This also moves PRECHANGE notifier down so that we call it just before starting
> frequency transition.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

