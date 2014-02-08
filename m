Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaBHE6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 23:58:16 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:27443
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbaBHE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 23:58:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 8 Feb 2014 12:58:29 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] v3.14-rc1 locking bug in system suspend
Message-ID: <20140208045824.GB10195@S2101-09.ap.freescale.net>
References: <20140205145408.GA3708@S2101-09.ap.freescale.net>
 <20140206145509.GB6610@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140206145509.GB6610@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 10:55:13PM +0800, Shawn Guo wrote:
> On Wed, Feb 05, 2014 at 10:54:10PM +0800, Shawn Guo wrote:
> > I start seeing the following locking bug on IMX6 with suspend operation
> > after moving to v3.14-rc1.  Before I start looking into the issue, I
> > would like to confirm if it's an IMX specific problem or one seen on
> > other platforms.  Please ask if you need more info.
> 
> Sorry.  This is not a new bug of v3.14-rc1.  It's been there with
> v3.13-rc for a while.  It looks like there is something wrong in the
> use of power_lock in struct snd_card.  Will dig into it.

Okay.  This is an IMX specific problem caused by audio driver.  I will
send a fix to alsa-devel list shortly.

Shawn

