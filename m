Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3C1CHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:07:45 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20972 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab3C1CHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:07:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 28 Mar 2013 10:07:34 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for
 clk_set_rate()
Message-ID: <20130328020732.GF5429@S2101-09.ap.freescale.net>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
 <Pine.LNX.4.64.1303272345260.9558@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1303272345260.9558@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:46:38PM +0100, Guennadi Liakhovetski wrote:
> Hi Shawn
> 
> On Mon, 25 Feb 2013, Guennadi Liakhovetski wrote:
> 
> > clk_set_rate() isn't supposed to accept approximate frequencies, instead
> > a supported frequency should be obtained from clk_round_rate() and then
> > used to set the clock.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Can I have your ack for this one, please?

Acked-by: Shawn Guo <shawn.guo@linaro.org>

