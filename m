Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaI1Dkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:40:42 -0400
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:4151
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921AbaI1Dkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:40:41 -0400
Date: Sat, 27 Sep 2014 22:40:12 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@shineypoop
To: Wolfram Sang <wsa@the-dreams.de>
CC: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <baruch@tkos.co.il>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>, <skuribay@pobox.com>,
        <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH] i2c designware add support of I2C standard mode
In-Reply-To: <20140920092456.GD1612@katana>
Message-ID: <alpine.DEB.2.10.1409272238450.2655@shineypoop>
References: <20140820124231.GD21734@leverpostej> <1408544948-22339-1-git-send-email-romainba@abilis.com> <20140920092456.GD1612@katana>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [24.206.110.125]
X-ClientProxiedBy: BLUPR02CA026.namprd02.prod.outlook.com (25.160.23.144) To
 DM2PR03MB317.namprd03.prod.outlook.com (10.141.54.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB317;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(54164003)(199003)(86152002)(83072002)(83506001)(87976001)(23726002)(92566001)(102836001)(92726001)(85852003)(31966008)(50986999)(47776003)(20776003)(33716001)(97736003)(21056001)(46406003)(54356999)(76176999)(66066001)(50466002)(4396001)(46102003)(101416001)(64706001)(86362001)(83322001)(19580405001)(19580395003)(90102001)(77982003)(74502003)(74662003)(81542003)(81342003)(77096002)(80022003)(79102003)(76482002)(42186005)(106356001)(85306004)(107046002)(105586002)(95666004)(99396003)(120916001)(10300001)(110136001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB317;H:shineypoop.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014, Wolfram Sang wrote:

> On Wed, Aug 20, 2014 at 04:29:08PM +0200, Romain Baeriswyl wrote:
> > From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
> > 
> > Some legacy devices support ony I2C standard mode at 100kHz.
> > This patch allows to select the standard mode through the DTS
> > with the use of the existing clock-frequency parameter.
> > 
> > When clock-frequency parameter is not set, the fast mode is selected.
> > Only when the parameter is set at 100000, the standard mode is selected.
> > 
> > Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> > Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
> 
> Applied to for-next, thanks to all involved!
> 
> 

I don't see this in 
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
Is this in i2c/i2c/for-next?

Alan
