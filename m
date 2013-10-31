Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3JaIGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:06:45 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:23707
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab3JaIGj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:06:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Thu, 31 Oct 2013 15:44:37 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@gmail.com>
CC: <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <pawel.moll@arm.com>, <linux-doc@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <galak@codeaurora.org>,
        <dmaengine@vger.kernel.org>, <ijc+devicetree@hellion.org.uk>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/4] ASoC: fsl_ssi: Add dual fifo mode support
Message-ID: <20131031074436.GG9605@MrMyself>
References: <cover.1383197521.git.b42378@freescale.com>
 <0e947536358af7bd6e179559006a3526801a1abe.1383197521.git.b42378@freescale.com>
 <52720CA4.3090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <52720CA4.3090003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Philippe

On Thu, Oct 31, 2013 at 08:54:12AM +0100, Philippe Rétornaz wrote:
> Hi
> 
> >
> >+			/* When using dual fifo mode, we need to keep watermark
> >+			 * as even numbers due to dma script limitation.
> >+			 */
> >+			ssi_private->dma_params_tx.maxburst /= 2;
> >+			ssi_private->dma_params_tx.maxburst *= 2;
> >+			ssi_private->dma_params_rx.maxburst /= 2;
> >+			ssi_private->dma_params_rx.maxburst *= 2;
> >
> 
> Why not using a mask here ?
> ssi_private->dma_params_tx.maxburst &= ~0x1;
> ssi_private->dma_params_rx.maxburst &= ~0x1;

I'll use this in v3. Thank you!

Nicolin Chen

> 
> Regards,
> 
> Philippe
> 
> 


