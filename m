Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaDAN05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:26:57 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:16847
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbaDAN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:26:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Tue, 1 Apr 2014 21:21:57 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: Re: [PATCH bisect 2/2] ASoC: fsl_sai: Separately enable interrupts
 for Tx and Rx streams
Message-ID: <20140401132156.GB27586@MrMyself>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-3-git-send-email-Guangyu.Chen@freescale.com>
 <20140401120715.GR2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140401120715.GR2269@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 01:07:15PM +0100, Mark Brown wrote:
> On Tue, Apr 01, 2014 at 11:17:07AM +0800, Nicolin Chen wrote:
> > We only enable one side interrupt for each stream since over/underrun
> > on the opposite stream would be resulted from what we previously did,
> > enabling TERE but remaining FRDE disabled, even though the xrun on the
> > opposite direction will not break the current stream.
> 
> This still doesn't apply against fsl-sai (nor for-next).

Sir, I just rebased my for-next branch again and found that it's missing
two applied patches: "ASoC: fsl_sai: Add isr to deal with error flag" and
"ASoC: fsl_sai: Improve fsl_sai_isr()", so that's why this PATCH-2 could
not be applied against it as it needs the macro that's included in the
patch "ASoC: fsl_sai: Add isr to deal with error flag".

What should I do now?

Thank you,
Nicolin

