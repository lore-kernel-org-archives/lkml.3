Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaH0Ha4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:30:56 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:56169
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751669AbaH0Haz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:30:55 -0400
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "jeremy@goop.org" <jeremy@goop.org>, Jan Beulich <JBeulich@suse.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Topic: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Index: Ac/BxOSGReNLYy7sSGa/c8GpUfDFQg==
Date: Wed, 27 Aug 2014 07:30:09 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(164054003)(199003)(99396002)(33656002)(50986999)(54356999)(46406003)(77096002)(31966008)(16796002)(86362001)(92566001)(92726001)(50466002)(90102001)(2201001)(6806004)(106466001)(81156004)(107046002)(229853001)(95666004)(85306004)(55846006)(26826002)(2421001)(83322001)(76482001)(1511001)(69596002)(68736004)(44976005)(86612001)(80022001)(79102001)(558084003)(81542001)(97736001)(97756001)(87936001)(21056001)(74502001)(74662001)(46102001)(23726002)(84676001)(2656002)(4396001)(77982001)(85852003)(20776003)(83072002)(47776003)(64706001)(81342001)(2501001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB615;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm curious about the difference. :-)

sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while set_bit() is used in all other places. What makes hv/xen special?

Thanks,
-- Dexuan

