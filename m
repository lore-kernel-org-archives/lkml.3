Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3GAKUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:20:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43985 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3GAKUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:20:15 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
Thread-Topic: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
Thread-Index: AQHOdkBUZXXc+h37l0WrESvq0oA7KJlPEVQAgAABQgCAAIgnMA==
Date: Mon, 1 Jul 2013 10:19:55 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229F0F8A@DBDE04.ent.ti.com>
References: <1372672182-14778-1-git-send-email-kishon@ti.com>
 <20130701100136.GA27646@sirena.org.uk> <51D1548E.4080008@ti.com>
In-Reply-To: <51D1548E.4080008@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: ABRAHAM, KISHON VIJAY
> Sent: Monday, July 01, 2013 3:36 PM
> To: Mark Brown
> Cc: lgirdwood@gmail.com; ldewangan@nvidia.com; gg@slimlogic.co.uk;
> sameo@linux.intel.com; J, KEERTHY; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3] regulator: palmas: model SMPS10 as two
> regulators
> 
> Hi,
> 
> On Monday 01 July 2013 03:31 PM, Mark Brown wrote:
> > On Mon, Jul 01, 2013 at 03:19:42PM +0530, Kishon Vijay Abraham I
> wrote:
> >> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
> >> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
> >> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2
> >> configures it in BOOST mode. For BYPASS mode
> regulator_allow_bypass()
> >> API can be used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be
> >> enabled using regulator_enable().
> >
> > This doesn't apply...
> 
> Ok. Which tree/branch should it be based on?. I created it on next-
> 20130628 as base.

I had submitted a patch on the same file which was pulled by Samuel.
Kishon is based on a branch which has my patch. I think that is missing in your
Branch. This is the reason why it is not applying.

> 
> Thanks
> Kishon

Regards,
Keerthy
