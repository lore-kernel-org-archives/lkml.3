Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJGOog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:44:36 -0400
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:57279
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbaJGOoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:44:34 -0400
Date: Tue, 7 Oct 2014 09:38:10 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Mark Brown <broonie@kernel.org>
CC: <linux@roeck-us.net>, <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <lgirdwood@gmail.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 3/4] pmbus: add regulator support
In-Reply-To: <20141003142746.GA24441@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1410070937540.9610@atx-linux-37>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com> <1412275071-6417-4-git-send-email-atull@opensource.altera.com> <20141003142746.GA24441@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR04CA052.namprd04.prod.outlook.com (10.141.249.170) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(41574002)(24454002)(199003)(85852003)(87976001)(102836001)(86152002)(69596002)(66066001)(85306004)(50986999)(86362001)(53416004)(54356999)(76176999)(19580395003)(19580405001)(83506001)(92566001)(92726001)(47776003)(81156004)(106356001)(105586002)(31966008)(97736003)(50466002)(120916001)(99396003)(23726002)(77096002)(42186005)(110136001)(101416001)(20776003)(4396001)(46102003)(107046002)(46406003)(122386002)(21056001)(64706001)(80022003)(95666004)(33716001)(76482002)(40100002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Mark Brown wrote:

> On Thu, Oct 02, 2014 at 01:37:50PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add support for simple on/off control of each channel.
> > 
> > To add regulator support, the pmbus part driver needs to add
> > regulator_desc information and number of regulators to its
> > pmbus_driver_info struct.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
>

Thanks!

Alan
