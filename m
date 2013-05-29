Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab3E2DJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:09:10 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:19789
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab3E2DJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:09:09 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 23:09:09 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIda00h1432Idc73hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 29 May 2013 10:54:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingchang Lu <b35083@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <daniel.lezcano@linaro.org>, <s.hauer@pengutronix.de>
Subject: Re: [PATCH v5] clocksource: add Freescale Vybrid pit timer support
Message-ID: <20130529025428.GE370@S2101-09.ap.freescale.net>
References: <1369732899-17142-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369732899-17142-1-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:21:39PM +0800, Jingchang Lu wrote:
> Add Freescale Vybrid Family period interrupt timer support.
> 
> Signed-off-by: Jingchang Lu <b35083@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

