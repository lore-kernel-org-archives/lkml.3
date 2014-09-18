Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaIRQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:14:47 -0400
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:41664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932214AbaIRQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:14:45 -0400
Date: Thu, 18 Sep 2014 10:52:24 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Wolfram Sang <wsa@the-dreams.de>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
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
In-Reply-To: <1408544948-22339-1-git-send-email-romainba@abilis.com>
Message-ID: <alpine.DEB.2.02.1409181050190.29539@atx-linux-37>
References: <20140820124231.GD21734@leverpostej> <1408544948-22339-1-git-send-email-romainba@abilis.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0042.namprd05.prod.outlook.com (10.141.20.12) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(24454002)(199003)(189002)(107046002)(87976001)(85306004)(46406003)(105586002)(79102003)(50466002)(31966008)(90102001)(42186005)(92566001)(64706001)(83072002)(76176999)(99396002)(19580395003)(97736003)(54356999)(86152002)(47776003)(77982003)(74662003)(46102003)(83506001)(81342003)(4396001)(83322001)(86362001)(80022003)(53416004)(106356001)(23726002)(81156004)(33716001)(77096002)(66066001)(76482002)(92726001)(20776003)(95666004)(69596002)(50986999)(81542003)(101416001)(19580405001)(85852003)(21056001)(74502003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Romain Baeriswyl wrote:

> From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
> 
> Some legacy devices support ony I2C standard mode at 100kHz.
> This patch allows to select the standard mode through the DTS
> with the use of the existing clock-frequency parameter.
> 
> When clock-frequency parameter is not set, the fast mode is selected.
> Only when the parameter is set at 100000, the standard mode is selected.
> 
> Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  drivers/i2c/busses/i2c-designware-platdrv.c |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
> 

Hi Wolfram,

This patch is really useful for us.  Is it going to be picked up?

Alan
