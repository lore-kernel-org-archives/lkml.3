Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaHVVUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:20:09 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:16576
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751517AbaHVVUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:20:07 -0400
Date: Fri, 22 Aug 2014 16:14:47 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 0/2] add regulator support for pmbus and ltc2978
In-Reply-To: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1408221614040.24915@atx-linux-37>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0057.namprd08.prod.outlook.com (10.141.200.37) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(199003)(164054003)(24454002)(46406003)(76482001)(74662001)(74502001)(77096002)(85306004)(42186005)(76176999)(77982001)(31966008)(102836001)(53416004)(107046002)(50986999)(54356999)(46102001)(80022001)(101416001)(33716001)(86362001)(83072002)(92566001)(83322001)(92726001)(83506001)(21056001)(23726002)(85852003)(20776003)(81342001)(81542001)(4396001)(87976001)(19580395003)(19580405001)(99396002)(66066001)(86152002)(69596002)(47776003)(79102001)(50466002)(81156004)(95666004)(105586002)(90102001)(64706001)(106356001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, atull@opensource.altera.com wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> This set of patches adds regulator support to pmbus_core.c and to
> ltc2978.c.
> 
> Other pmbus parts can use this to add their own regulator support.
> 
> Current ltc2978 support is limited to enable/disable.
> 
> Tested on ltc2978.  Looking at the datasheets for the other parts
> supported by ltc2978.c, it looks like it should work.
> 
> Thanks,
> Alan
> 
> Alan Tull (2):
>   pmbus: add regulator support
>   pmbus: ltc2978: add regulator enable disable
> 
>  drivers/hwmon/pmbus/Kconfig      |    9 +++++
>  drivers/hwmon/pmbus/ltc2978.c    |   69 ++++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/pmbus/pmbus.h      |    7 ++++
>  drivers/hwmon/pmbus/pmbus_core.c |   40 ++++++++++++++++++++++
>  4 files changed, 125 insertions(+)
> 
> -- 
> 1.7.9.5
> 
> 

I've posted V2 of these patches.

Alan

