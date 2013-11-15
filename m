Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3KODYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:24:35 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:43513
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab3KODY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:24:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432I168aJzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 15 Nov 2013 11:15:37 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <timur@tabi.org>, <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <linux@arm.linux.org.uk>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>
Subject: Re: [PATCH 0/2] Add monaural audio support for fsl_ssi.c
Message-ID: <20131115031536.GB745@MrMyself>
References: <1384427230-979-1-git-send-email-b42378@freescale.com>
 <20131115030247.GC11014@S2101-09.ap.freescale.net>
 <20131115025956.GA745@MrMyself>
 <20131115032250.GD11014@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131115032250.GD11014@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:22:52AM +0800, Shawn Guo wrote:
> On Fri, Nov 15, 2013 at 10:59:57AM +0800, Nicolin Chen wrote:
> > Hi Shawn,
> >    
> > On Fri, Nov 15, 2013 at 11:02:49AM +0800, Shawn Guo wrote:
> > > On Thu, Nov 14, 2013 at 07:07:08PM +0800, Nicolin Chen wrote:
> > > > This series of patches need to be applied into one single tree because
> > > > the second patch depends on the first one. Without it, SSI would playback
> > > > constant noise to the right channel when playback monaural audio files on
> > > > i.MX6 Series board.
> > > 
> > > Let me try to understand if the dependency is true.
> > > 
> > > Saying I apply the DTS patch on IMX tree while Mark apply the fsl_ssi
> > > patch on his tree, will there be any regression on either IMX tree or
> > > Mark's tree?  The monaural playback on imx6qdl never worked, so it's not
> > > a regression.  If there is no regression on either tree, there is no
> > > dependency to maintain.
> > 
> > It's fair enough to understand in this way. It looks like I misunderstood
> > the dependency here.
> > 
> > Do I need to resend them separately?
> 
> No, I will just pick up the DTS patch with some testing.
> 
> Shawn

Thank you.
Nicolin Chen


