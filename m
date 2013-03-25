Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3CYPZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:25:12 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:14715
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120Ab3CYPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:25:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI1432I179dNzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 25 Mar 2013 23:25:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
CC: Hector Palacios <hector.palacios@digi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: BUG: soft lockup when recording audio on MX28EVK with ASoC
 sgtl5000
Message-ID: <20130325152548.GD30232@S2101-09.ap.freescale.net>
References: <51502C87.8050902@digi.com>
 <201303251310.55122.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201303251310.55122.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 01:10:54PM +0100, Marek Vasut wrote:
> Dear Hector Palacios,
> 
> CCing Shawn, this might also explain the touchscreen issue.
> 
> > Hello,
> > 
> > I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000
> > (kernel v3.8) with:
> > 
> > 	arecord -M -f cd sound.wav --duration 10
> > 
> > and got a scheduler message:
> > 
> > [  789.041847] [sched_delayed] sched: RT throttling activated

Hmm, I'm not sure if v3.8 is the first place where audio recording gets
broken.  Does v3.7 even work for you?

Shawn

