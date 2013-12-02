Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3LBPYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:24:25 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:51711
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab3LBPYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:24:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Mon, 2 Dec 2013 23:21:31 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <timur@tabi.org>, <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <lgirdwood@gmail.com>
Subject: Re: [PATCH v2] ASoC: fsl_ssi: Add monaural audio support for
 non-ac97 interface
Message-ID: <20131202152130.GB8609@MrMyself>
References: <1384532729-6588-1-git-send-email-b42378@freescale.com>
 <20131202115617.GV27568@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131202115617.GV27568@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 11:56:17AM +0000, Mark Brown wrote:
> On Sat, Nov 16, 2013 at 12:25:29AM +0800, Nicolin Chen wrote:
> > The normal mode of SSI allows it to send/receive data to/from the first
> > slot of each period. So we can use this normal mode to trick I2S signal
> > by puting/getting data to/from the first slot only (the left channel)
> > so as to support monaural audio playback and recording.
> 
> This looks OK but doesn't apply against current code, can you please
> check and resend?

Ah, I rebased it on the dual-fifo set. Sorry I didn't make it clean.
I will resend it. Thank you.


