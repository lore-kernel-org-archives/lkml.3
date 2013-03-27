Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3C0MAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:00:35 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49116
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab3C0MAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:00:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z1039mz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 27 Mar 2013 20:00:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v9 RESEND 0/4] Add generic driver for on-chip SRAM
Message-ID: <20130327120017.GA2674@S2101-09.ap.freescale.net>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
 <1364373214.5442.1.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364373214.5442.1.camel@pizza.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:33:34AM +0100, Philipp Zabel wrote:
> Am Mittwoch, den 20.03.2013, 11:52 +0100 schrieb Philipp Zabel:
> > Hi, last time I posted was a bit close to the merge window, so I'm
> > reposting now. Greg, Arnd, could you take the first two patches?
> 
> Ping,
> 
> can I do anything to help move this along?

You haven't indicated how the series should be merged and by whom.  I
think we should have the first two patches get in through either
Andrew's tree or Greg's tree, since Andrew is handling genalloc and Greg
is handling drivers/misc.

Greg, can you please give your ACK on the second patch to have the first
two go via Andrew's tree?  Otherwise, we can try to ask for Andrew's
ACK on the first patch to have them go through yours.  Please tell.

Shawn

