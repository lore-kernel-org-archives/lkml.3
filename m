Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaCRU0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:26:38 -0400
Received: from mail-bl2on0078.outbound.protection.outlook.com ([65.55.169.78]:62809
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751593AbaCRU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:26:35 -0400
Date: Tue, 18 Mar 2014 14:55:03 -0500
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: Mark Brown <broonie@kernel.org>
CC: Paul Handrigan <paul.handrigan@cirrus.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Nicolin Chen <Guangyu.Chen@freescale.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <lars@metafoo.de>
Subject: Re: [PATCH v3] ASoC: cs42888: Add codec driver support
In-Reply-To: <20140318195159.GQ11706@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1403181454470.14838@heelrod>
References: <1394538091-19513-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140318131033.GC11706@sirena.org.uk>
 <alpine.DEB.2.02.1403180936200.14838@heelrod>
 <alpine.DEB.2.00.1403181202310.7177@phandrigan-desktop>
 <20140318195159.GQ11706@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.3.20;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(458001)(24454002)(51704005)(199002)(189002)(80976001)(69226001)(83322001)(44976005)(97336001)(85306002)(92566001)(51856001)(97186001)(87936001)(81342001)(6806004)(33716001)(92726001)(4396001)(50986001)(87266001)(49866001)(47976001)(47736001)(46102001)(74706001)(50466002)(93136001)(74876001)(93516002)(95666003)(56816005)(94316002)(90146001)(81542001)(65816001)(23726002)(83072002)(56776001)(85852003)(31966008)(74502001)(47446002)(74662001)(47776003)(63696002)(20776003)(81686001)(76786001)(77982001)(80022001)(53806001)(54316002)(83506001)(54356001)(76482001)(95416001)(86362001)(94946001)(77096001)(76796001)(74366001)(79102001)(59766001)(81816001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB047;H:mail1.cirrus.com;FPR:6C55E5A0.4CD84725.3FD74B70.4E06FD8.2010C;MLV:sfv;PTR:mail1.cirrus.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 0154C61618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2014, Mark Brown wrote:

> On Tue, Mar 18, 2014 at 12:08:02PM -0500, Paul Handrigan wrote:
>> On Tue, 18 Mar 2014, Brian Austin wrote:
>
>>> Driver looks good to me. I think we should name it the cs42xx8 since this
>>> actually covers CS42448 and CS42888. The CS42888 is derived from the
>>> CS42448.
>
>> V3 looks good. As Brian said, the name should be changed to cs42xx8.
>
> Great, so if Nicolin resubmits with the rename when he gets back he can
> add acks from both of you?  The driver looked fine to me too.
>
Yes sir
