Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3HLIeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:34:10 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:25065
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab3HLIeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:34:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z1039mcb8kz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 12 Aug 2013 16:34:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/44] cpufreq: imx6q: Use generic cpufreq routines
Message-ID: <20130812083412.GI25061@S2101-09.ap.freescale.net>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
 <6d7504823a31aea1e4773998f60720494fb0e6b6.1376116345.git.viresh.kumar@linaro.org>
 <20130812075841.GG25061@S2101-09.ap.freescale.net>
 <CAKohponEs-5WEqKTkgyiZP0rfgHzSDy3O9Hyx4U0Xkc-wa-9Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohponEs-5WEqKTkgyiZP0rfgHzSDy3O9Hyx4U0Xkc-wa-9Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 01:40:36PM +0530, Viresh Kumar wrote:
> On 12 August 2013 13:28, Shawn Guo <shawn.guo@linaro.org> wrote:
> > On Sat, Aug 10, 2013 at 12:14:17PM +0530, Viresh Kumar wrote:
> >> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> >> and .attr. So its better if we have generic routines for them which can be used
> >> by cpufreq drivers then.
> >>
> >> This patch uses these generic routines for this driver.
> >>
> >> Cc: Shawn Guo <shawn.guo@linaro.org>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > Shawn Guo <shawn.guo@linaro.org>
> 
> I assume you meant an Ack here :)

Ah, yeah.

Acked-by: Shawn Guo <shawn.guo@linaro.org>

