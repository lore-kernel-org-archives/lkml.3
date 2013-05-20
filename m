Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3ETDVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:21:12 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:47369
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab3ETDVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:21:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI103dKzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 20 May 2013 11:21:16 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lu Jingchang-B35083 <B35083@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3] clocksource: add MVF600 pit timer support
Message-ID: <20130520032114.GC25113@S2101-09.ap.freescale.net>
References: <1368684924-1560-1-git-send-email-b35083@freescale.com>
 <20130520022747.GA25113@S2101-09.ap.freescale.net>
 <B56CDBE15CE27145A4B77D2D24263E851CB223@039-SN1MPN1-003.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E851CB223@039-SN1MPN1-003.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 03:08:54AM +0000, Lu Jingchang-B35083 wrote:
> [Lu Jingchang-B35083] 
>   I am not sure MVF5xx and MVF7xx have the same PIT block, if you have information that it is the same on other Vybrid SoCs, it is ok to change the driver name to mvf. Thanks!

Even the PIT block on other Vybrid SoCs have differences from the one
integrated on mvf600, we can handle them using device tree compatible
string.  And that's why we need to encode SoC name in compatible.

> [Lu Jingchang-B35083] 
> PIT0 and PIT1 can be chained to build a 64-bit timer, so PIT2 and PIT3 are selected as the clocksource and clockevent device, and leave PIT0 and PIT1 unused for anyone else who needs them. Thanks!

This could be an useful info to be in the comment.

Shawn

