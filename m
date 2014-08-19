Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaHSU3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:29:30 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:10220
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbaHSU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:29:27 -0400
Date: Tue, 19 Aug 2014 15:24:09 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Wolfram Sang <wsa@the-dreams.de>
CC: <baruch@tkos.co.il>, <mika.westerberg@linux.intel.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>, <skuribay@pobox.com>,
        <Romain.Baeriswyl@abilis.com>, <rafael.j.wysocki@intel.com>,
        <alan@linux.intel.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] i2c: designware: device tree bindings for i2c speed
 mode
In-Reply-To: <20140819191521.GA7306@katana>
Message-ID: <alpine.DEB.2.02.1408191519190.22837@atx-linux-37>
References: <1408473276-10847-1-git-send-email-atull@opensource.altera.com> <20140819191521.GA7306@katana>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA026.namprd04.prod.outlook.com (10.141.154.144) To
 DM2PR03MB319.namprd03.prod.outlook.com (10.141.54.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009006)(6009001)(24454002)(189002)(199003)(51704005)(101416001)(50986999)(106356001)(105586002)(74662001)(50466002)(77096002)(86362001)(53416004)(81156004)(81542001)(85306004)(81342001)(110136001)(107046002)(33716001)(20776003)(80022001)(31966008)(66066001)(47776003)(64706001)(74502001)(95666004)(102836001)(76176999)(54356999)(21056001)(79102001)(83506001)(69596002)(87976001)(19580395003)(19580405001)(46406003)(83322001)(4396001)(83072002)(85852003)(23726002)(92726001)(77982001)(42186005)(92566001)(99396002)(86152002)(46102001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB319;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2014, Wolfram Sang wrote:

> On Tue, Aug 19, 2014 at 01:34:35PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add "speed-mode" Device Tree property to select between
> > standard and fast i2c mode.  Previously, driver was hardwired
> > as fast mode.  Default to fast mode if property is not
> > present.
> 
> NACK. This should be deduced from the clock-frequency setting...

I just sent out a new patch that looks at the clock-frequency setting.

Alan

