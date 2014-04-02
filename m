Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaDBNOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:14:31 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:38059
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758692AbaDBNO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:14:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dIc89bh146fI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh87h2a8h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 2 Apr 2014 21:14:08 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
CC: CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
Message-ID: <20140402131404.GE8558@dragon>
References: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com>
 <20140321222320.14370739@e6520eb>
 <1762157698.5689069.1395675049240.JavaMail.zimbra@adeneo-embedded.com>
 <20140324164141.51b85f8c@e6520eb>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20140324164141.51b85f8c@e6520eb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 04:41:41PM +0100, Eric Bénard wrote:
> Hi Hubert,
> 
> Le Mon, 24 Mar 2014 16:30:49 +0100 (CET),
> CHAUMETTE Hubert <hchaumette@adeneo-embedded.com> a écrit :
> > > From: "Eric Bénard" <eric@eukrea.com>
> > > that's board specific (the needed delay depends on the routing delay on
> > > the PCB), so this should not go in a generic file.
> > > 
> > > Eric
> > > 
> > 
> > I admit it may need to be in a separate function, but this file already contains
> > board-specific fixups (for imx6q sabrelite, Data Modul eDM-QMX6).
> > 
> true but that's not a reason to add more ;-)
> 
> > Anyway, do you have any suggestion for the location I should put it ?
> > 
> no idea at the moment, I simply used your patch to bring this issue on
> the ML as we recently needed to patch the default values for testing
> mainline kernel on a custom boards.

Hmm, can such board-specific fixups be pushed down to bootloader?

Shawn

