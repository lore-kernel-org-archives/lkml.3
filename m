Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3GBKlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:41:42 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:59009
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab3GBKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:41:41 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI148cI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23hbe9i1155h)
Subject: Re: Multiple DA9055 chips
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <20130702103101.GH27646@sirena.org.uk>
References: <20130701164833.GL27646@sirena.org.uk>
	 <1372757513.28415.2.camel@matrix> <20130702093130.GX27646@sirena.org.uk>
	 <1372759357.29900.3.camel@matrix>  <20130702103101.GH27646@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 2 Jul 2013 16:37:34 +0530
Message-ID: <1372763254.2770.29.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 11:31 +0100, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 03:32:37PM +0530, Ashish Chavan wrote:
> 
> > > OK, in that case the CODEC driver is just plain broken then.  Did anyone
> > > actually test this stuff?  Please fix.
> 
> > Yes, I think so. Actually the CODEC driver was merged before PMIC ino
> > main line and was tested at that time. I will check with PMIC team if
> > they did test with CODEC.
> 
> > I guess the fix should be in PMIC, right?
> 
> Both drivers need to be changed.

OK. We will fix both of them.
Thanks for pointing this out.


