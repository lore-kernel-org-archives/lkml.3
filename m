Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbaFJBQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:16:24 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:52871
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932989AbaFJBQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:16:21 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9] ARM: Berlin: USB support
Thread-Topic: [PATCH 0/9] ARM: Berlin: USB support
Thread-Index: AQHPgNWn1IcEQIHdxE6Qw/22comgr5tou3qA///aHYCAAPoTIA==
Date: Tue, 10 Jun 2014 01:16:18 +0000
Message-ID: <63fc1fa8280b498182ebf8a3654732b9@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140609043019.GA32255@shlinux1.ap.freescale.net>
 <53958913.8080708@gmail.com>
In-Reply-To: <53958913.8080708@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0238AEEDB0
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(199002)(189002)(101416001)(21056001)(81342001)(83322001)(2656002)(76482001)(87936001)(83072002)(54356999)(76176999)(77982001)(81542001)(50986999)(46102001)(92566001)(86362001)(4396001)(66066001)(80022001)(31966008)(74502001)(74662001)(33646001)(99396002)(20776003)(79102001)(74316001)(85852003)(64706001)(76576001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB226;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> we are early in the cycle and I feel there will be a v2 of the chipidea
> stub. IMHO, controlling the vbus regulator should not be business of the
> phy driver, so ci will have to deal with it.
> 

vbus handling has already in chipidea common code, it treats vbus as a regulator.
So, the glue layer only needs to register and add vbus-supply to dts file, no source
code change is needed.

Peter

> Anyways, good to know you are fine with it already!
> 
> Sebastian
