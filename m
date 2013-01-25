Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3AYI2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:28:32 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:42374
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab3AYI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:28:30 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1hbe9i1155h)
Subject: Re: [patch v1 2/5] regulator: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
In-Reply-To: <20130123160354.GE4565@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED4313C7F1@KCHJEXMB03.kpit.com>
	 <1358757312.11746.11.camel@dhruva>
	 <20130123160354.GE4565@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jan 2013 13:56:40 +0530
Message-ID: <1359102400.6620.3.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 00:03 +0800, Mark Brown wrote:
> On Mon, Jan 21, 2013 at 02:05:12PM +0530, Ashish Jangam wrote:
> 
> > > What makes you say that there is a dependency here?  It's really not at
> > > all obvious why a change to the primary IRQ signalling mechanism would
> > > affect the internal interrupts of the device.
> 
> > Yes, functionally this dependency should not matter.However, if
> > mfd/primary irq state is low and its components are high then it shall
> > not look good. Therefore the term dependency was used, probably I should
> > have written it in a different manner.
> 
> This logic doesn't follow terribly directly - looking at what you've
> posted it in fact seems that the trigger type is irrelevant in the
> function drivers?
Though it is functionally irrelevant but in the code setting the primary
irq to low and functional driver to high may confuse the code reader.
However I leave this decision to you.


