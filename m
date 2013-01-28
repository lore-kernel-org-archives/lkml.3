Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3A1IiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:38:10 -0500
Received: from [216.32.181.182] ([216.32.181.182]:25963 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab3A1IiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:38:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1102I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 28 Jan 2013 16:37:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] cpufreq, highbank: add support for highbank cpufreq
Message-ID: <20130128083716.GE31689@S2101-09.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1359143205-20279-5-git-send-email-mark.langsdorf@calxeda.com>
 <20130126143950.GA7079@S2101-09.ap.freescale.net>
 <1523559.2KevGvelzH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1523559.2KevGvelzH@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Sat, Jan 26, 2013 at 11:24:12PM +0100, Rafael J. Wysocki wrote:
> > As we are moving to multiplatform build, this init function will run
> > on all other platforms built together with highbank.  We should
> > probably eliminate that effect.
> 
> That change can be made on top of the Mark's patches I think, right?
> 
Yes.

> If so, I'd prefer it that way.  The Mark's patches have been in a limbo for
> too long already and that issue doesn't seem to be serious enough to block
> them any longer.
> 
Ok, I will take care of the changes needed on highbank.  Do you have
a branch with Mark's series and the EXPORT_SYMBOL() one applied,
so that I can start my patch from there.

Shawn

