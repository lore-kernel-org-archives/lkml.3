Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaDOCjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:39:15 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:10505
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaDOCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:39:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Tue, 15 Apr 2014 10:33:26 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>
Subject: Re: [PATCH] ASoC: fsl_sai: Fix incorrect condition check in trigger()
Message-ID: <20140415023325.GE7197@MrMyself>
References: <1397225400-2769-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140414203126.GB25182@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140414203126.GB25182@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:31:26PM +0100, Mark Brown wrote:
> On Fri, Apr 11, 2014 at 10:10:00PM +0800, Nicolin Chen wrote:
> 
> > +		/* Check if the opposite FRDE is also disabled */
> > +		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
> 
> I've applied this since it's a fix but this is *not* a triumph of
> legibility, the ternery operator is often not helpful.

It looks like I've got a bad habit again. I'll be careful next time.

Thank you for reminding me,
Nicolin

