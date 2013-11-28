Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab3K1Ddk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:33:40 -0500
Received: from [213.199.154.189] ([213.199.154.189]:21032 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab3K1Ddi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:33:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Fabio Estevam <Fabio.Estevam@freescale.com>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
Thread-Topic: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
Thread-Index: AQHO6pRwzUzMP/nWTkmv/o3JfSCBM5o3hgOAgAD0umCAAHdkgIABCp/w
Date: Thu, 28 Nov 2013 03:31:03 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828CF777@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
 <20131126134411.GQ14725@sirena.org.uk>
 <1DD289F6464F0949A2FCA5AA6DC23F828CE2A8@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131127112725.GT14725@sirena.org.uk>
In-Reply-To: <20131127112725.GT14725@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
> regulator consumers
> 
> On Wed, Nov 27, 2013 at 08:13:03AM +0000, Li Xiubo wrote:
> 
> Please fix your mailer to word wrap within paragraphs, it makes your mail
> much more legible.
> 

Yes, I will.


> > There is one dependency patch: "regulator: core: Provide a dummy
> regulator with full constraints".
> 
> > From the dependency patch, we can see that using regulator_get_optional()
> instead can resovle the problem you descripted above.
> 
> > When or will this dependency patch be merged into the -next tree ?
> 
> That patch is already in mainline.
> 

Okey.

> > > I'd expect to see a commit description that describes how the driver
> > > currently tries to handle this, why it doesn't work and how the
> > > patch fixes it.
> 
> > The SGTL5000 requires 2 external power supplies: VDDA and VDDIO. An
> > optional third external power supply VDDD may be provided externally
> 
> You need to put your working through of this stuff in the commit message.

I did it already, please see the next version.

--
Best Regards,


