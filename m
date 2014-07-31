Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaGaLck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:32:40 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:55022
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750702AbaGaLcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:32:39 -0400
Date: Thu, 31 Jul 2014 13:32:18 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Mark Rutland <mark.rutland@arm.com>, Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140731113218.GQ4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <20140730154626.GD20162@leverpostej>
 <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.199.242]
X-ClientProxiedBy: AMSPR01CA004.eurprd01.prod.exchangelabs.com
 (10.255.167.149) To SN2PR0701MB813.namprd07.prod.outlook.com (25.160.16.147)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0289B6431E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6069001)(6009001)(24454002)(164054003)(199002)(189002)(51704005)(81342001)(46406003)(95666004)(46102001)(81542001)(105586002)(4396001)(23726002)(80022001)(47776003)(64706001)(106356001)(20776003)(83506001)(74502001)(66066001)(77982001)(77096002)(85306003)(76482001)(50466002)(74662001)(76506005)(79102001)(92726001)(33656002)(107046002)(76176999)(87976001)(92566001)(83072002)(21056001)(97756001)(31966008)(101416001)(42186005)(102836001)(50986999)(54356999)(93886003)(86362001)(85852003)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR0701MB813;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob and Arnd,

On 30.07.14 11:37:38, Rob Herring wrote:
> >> +/*
> >> + * Cavium Thunder DTS file
> >> + *
> >> + * Copyright (C) 2013, Cavium Inc.
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public License as
> >> + * published by the Free Software Foundation; either version 2 of
> >> + * the License, or (at your option) any later version.
> >> + */
> 
> You may want to reconsider if this should be BSD.

I understand that this is an issue for the inclusion in firmware
binaries. Though, we just followed common practice here which is
gplv2.

I looked through existing dts files in arch/arm*/dts/* and about 590
of 720 have a gplv2 statement in. The other files don't have any and
thus following the COPYING file which is gplv2 too.                 

It is my understanding that the kernel requires licensing under gplv2.
So an option would be to dual license the dts file, e.g. with BSD. How
is this typically handled? Are there other repositories where dts
files are included with a different license model than gplv2?

Thanks,

-Robert
