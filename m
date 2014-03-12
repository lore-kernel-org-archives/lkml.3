Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaCLCFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:05:13 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:44495
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007AbaCLCFK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:05:10 -0400
X-Forefront-Antispam-Report: CIP:141.131.3.20;KIP:(null);UIP:(null);IPV:NLI;H:mail1.cirrus.com;RD:mail1.cirrus.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097hz2dh7bh109h2a8h839h944hd25he5bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2052h20b3h2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h1155h)
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Mark Brown <broonie@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Nicolin Chen <Guangyu.Chen@freescale.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v2] ASoC: cs42888: Add codec driver support
Thread-Topic: [PATCH v2] ASoC: cs42888: Add codec driver support
Thread-Index: AQHPPRu/Pw8nwgNZUEGWM89RfZp8hprcWloAgAAECQCAAC+JAIAAJs+/
Date: Wed, 12 Mar 2014 02:05:00 +0000
Message-ID: <03E7E694-045D-4C8B-A1A4-98CC306D6D63@cirrus.com>
References: <1394536791-8381-1-git-send-email-Guangyu.Chen@freescale.com>
 <alpine.DEB.2.02.1403111026280.3558@heelrod>
 <531F320E.70605@metafoo.de>,<20140311184606.GW28112@sirena.org.uk>
In-Reply-To: <20140311184606.GW28112@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cirrus.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> On Mar 11, 2014, at 13:46, "Mark Brown" <broonie@kernel.org> wrote:
>> 
>> On Tue, Mar 11, 2014 at 04:55:58PM +0100, Lars-Peter Clausen wrote:
>> On 03/11/2014 04:41 PM, Brian Austin wrote:
> 
>>> So WRT the CS42888, this is one device in a series of 2 devices that are
>>> register compatible with the only difference being that the CS42488 has 2
>>> extra ADC's. Same die and same DeviceID.
> 
>>> Would it make more sense to submit the driver with the extra ADC's to make
>>> it feature complete for both devices? Wouldn't be odd to have 2 drivers that
>>> do the same for 98% of the code.
> 
>> This should be in one driver. But support for the second device can
>> always be added in a follow up patch.
> 
> Yes, we can add support later.  It might be helpful to name the driver
> with some generic name I guess.
CS42xx8 would work.

We have a CS42448 and the CS42888. The difference is the 2 extra ADC's on the CS42448. I can add those later.

I still would like to go over some of the v2 code though before a v3 is sent.

Thanks
Brian
