Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaHOVys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:54:48 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:44976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750763AbaHOVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:54:47 -0400
Date: Fri, 15 Aug 2014 16:34:49 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: power supply gating with ltc2978
Message-ID: <alpine.DEB.2.02.1408151623140.21645@atx-linux-37>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0051.namprd08.prod.outlook.com (10.141.200.31) To
 BY2PR03MB315.namprd03.prod.outlook.com (10.141.139.25)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009004)(6009001)(199003)(164054003)(189002)(20776003)(92566001)(107046002)(80022001)(46102001)(81342001)(33716001)(81542001)(101416001)(77982001)(76482001)(86362001)(50466002)(83506001)(229853001)(102836001)(95666004)(47776003)(99396002)(4396001)(42186005)(69596002)(106356001)(31966008)(74502001)(105586002)(83322001)(81156004)(85852003)(54356999)(74662001)(86152002)(21056001)(23726002)(87976001)(66066001)(79102001)(53416004)(110136001)(85306004)(50986999)(46406003)(83072002)(64706001)(92726001)(77096002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am interested in adding functionality to be able to gate power supplies 
going through a ltc2978.  I see that there is a hwmon driver already 
existing (hwmon/pmbus/ltc2978.c).  I see some of the other hwmon drivers 
have MFD's.  It looks like this ltc driver would need a MFD and a 
regulator driver added.  However I don't see other pmbus hwmon drivers
using MFD.

So I am asking for recommendations and reservations on how to proceed here 
before I get too far with this.

Thanks,
Alan Tull

