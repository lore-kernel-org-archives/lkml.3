Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbaCRTkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:40:23 -0400
Received: from mail-bn1bon0076.outbound.protection.outlook.com ([157.56.111.76]:42149
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757782AbaCRTkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:40:17 -0400
X-Greylist: delayed 7161 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 15:40:16 EDT
Date: Tue, 18 Mar 2014 12:08:02 -0500
From: Paul Handrigan <paul.handrigan@cirrus.com>
X-X-Sender: phandrigan@phandrigan-desktop
To: Brian Austin <brian.austin@cirrus.com>
CC: Mark Brown <broonie@kernel.org>, Nicolin Chen <Guangyu.Chen@freescale.com>,
        <Paul.Handrigan@cirrus.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <lars@metafoo.de>
Subject: Re: [PATCH v3] ASoC: cs42888: Add codec driver support
In-Reply-To: <alpine.DEB.2.02.1403180936200.14838@heelrod>
Message-ID: <alpine.DEB.2.00.1403181202310.7177@phandrigan-desktop>
References: <1394538091-19513-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140318131033.GC11706@sirena.org.uk>
 <alpine.DEB.2.02.1403180936200.14838@heelrod>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.3.20;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(458001)(51704005)(189002)(199002)(24454002)(95416001)(56816005)(63696002)(47776003)(95666003)(20776003)(94946001)(83072002)(74502001)(80022001)(31966008)(23726002)(74662001)(47446002)(85852003)(97336001)(81686001)(83322001)(59766001)(54316002)(76796001)(80976001)(81816001)(97186001)(65816001)(90146001)(94316002)(92566001)(92726001)(86362001)(93516002)(77096001)(76786001)(76482001)(87266001)(50466002)(74876001)(51856001)(85306002)(93136001)(81342001)(44976005)(53806001)(74366001)(87936001)(54356001)(81542001)(4396001)(79102001)(56776001)(77982001)(74706001)(69226001)(83506001)(49866001)(50986001)(6806004)(47976001)(33716001)(47736001)(46102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB056;H:mail1.cirrus.com;FPR:6C45EDA2.F1C5C3D.3FF77B74.34704FF9.20118;MLV:sfv;PTR:mail1.cirrus.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 0154C61618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Mar 2014, Brian Austin wrote:

> On Tue, 18 Mar 2014, Mark Brown wrote:
>
>> On Tue, Mar 11, 2014 at 07:41:31PM +0800, Nicolin Chen wrote:
>>> This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
>>> has four 24-bit A/D and eight 24-bit D/A converters.
>> 
>> Brian, Paul - any review comments on this?
>> 
> Driver looks good to me. I think we should name it the cs42xx8 since this 
> actually covers CS42448 and CS42888. The CS42888 is derived from the CS42448.
>
V3 looks good. As Brian said, the name should be changed to cs42xx8.

