Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3GBJHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:07:54 -0400
Received: from [216.32.181.186] ([216.32.181.186]:11692 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932528Ab3GBJHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:07:51 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dI936eIzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23hbe9i1155h)
Subject: Re: Multiple DA9055 chips
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <20130701164833.GL27646@sirena.org.uk>
References: <20130701164833.GL27646@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 2 Jul 2013 15:01:53 +0530
Message-ID: <1372757513.28415.2.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 17:48 +0100, Mark Brown wrote:
> It seems we have two drivers in mainline for da9055 on I2C.  We've got
> one in sound/soc/codecs/da9055.c and one in drivers/mfd/da9055-i2c.c,
> both registering themselves identically.  What's going on here?  Is this
> a combined CODEC and PMIC, has someone decided to release two chips with
> the same name or is one of the drivers misnamed?

Yes, this is a combined CODEC and PMIC.


