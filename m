Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaHUW1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:27:13 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:37857
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755295AbaHUW1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:27:09 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 0/2] add regulator support for pmbus and ltc2978
Date: Thu, 21 Aug 2014 17:21:24 -0500
Message-ID: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA061.namprd04.prod.outlook.com (10.141.154.179) To
 DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(164054003)(199003)(189002)(66066001)(77982001)(47776003)(76482001)(77156001)(31966008)(83322001)(102836001)(74502001)(101416001)(105586002)(80022001)(20776003)(87286001)(95666004)(81156004)(74662001)(106356001)(50466002)(64706001)(85306004)(85852003)(50226001)(107046002)(86362001)(93916002)(79102001)(46102001)(92566001)(86152002)(89996001)(4396001)(42186005)(83072002)(53416004)(69596002)(50986999)(87976001)(92726001)(104166001)(48376002)(19580405001)(21056001)(229853001)(77096002)(99396002)(62966002)(81342001)(81542001)(88136002)(19580395003)(33646002)(90102001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB320;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

This set of patches adds regulator support to pmbus_core.c and to
ltc2978.c.

Other pmbus parts can use this to add their own regulator support.

Current ltc2978 support is limited to enable/disable.

Tested on ltc2978.  Looking at the datasheets for the other parts
supported by ltc2978.c, it looks like it should work.

Thanks,
Alan

Alan Tull (2):
  pmbus: add regulator support
  pmbus: ltc2978: add regulator enable disable

 drivers/hwmon/pmbus/Kconfig      |    9 +++++
 drivers/hwmon/pmbus/ltc2978.c    |   69 ++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/pmbus/pmbus.h      |    7 ++++
 drivers/hwmon/pmbus/pmbus_core.c |   40 ++++++++++++++++++++++
 4 files changed, 125 insertions(+)

-- 
1.7.9.5

