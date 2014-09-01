Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaIAUgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:36:08 -0400
Received: from mail-am1lrp0014.outbound.protection.outlook.com ([213.199.154.14]:49098
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbaIAUgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:36:06 -0400
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "Linux (Kernel) Mailingliste (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: AW: Early microcode not being loaded
Thread-Topic: Early microcode not being loaded
Thread-Index: Ac+iyGu0bjnYxuYsRMClhSHnVLMEqQABjuOAAADRWAAIz+TOwAAEE7IAAACWpWA=
Date: Mon, 1 Sep 2014 20:36:01 +0000
Message-ID: <53f0d26fec8e47be81dd395da4cc94ed@DB4PR04MB265.eurprd04.prod.outlook.com>
References: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
 <20140718212427.GB11098@pd.tnic>
 <4c348de3b92a49c58bf17777873410dd@DB4PR04MB265.eurprd04.prod.outlook.com>
 <06765c8a9ea84f8a81d595e05dcfe10e@DB4PR04MB265.eurprd04.prod.outlook.com>
 <20140901201752.GB18675@khazad-dum.debian.net>
In-Reply-To: <20140901201752.GB18675@khazad-dum.debian.net>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2003:56:2f1b:4520:bd2a:3d5e:8000:5745]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(979002)(6009001)(41574002)(199003)(189002)(92566001)(95666004)(21056001)(85306004)(86362001)(83072002)(31966008)(81542001)(105586002)(87936001)(81342001)(46102001)(79102001)(110136001)(15975445006)(85852003)(74662001)(64706001)(90102001)(20776003)(83322001)(101416001)(4396001)(76576001)(99396002)(229853001)(75402002)(77982001)(74316001)(108616004)(74482001)(76176999)(106356001)(33646002)(107886001)(19580395003)(50986999)(93886004)(2656002)(54356999)(107046002)(3826002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DB4PR04MB266;H:DB4PR04MB265.eurprd04.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ck@conrad-kostecki.de; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That file is way too big.  In fact, it is exactly the size of the newest ".dat" file from Intel.  The kernel doesn't grok that text format, the microcode updates have to be converted to binary format, first.

> I suggest you use "iucode_tool -S --write-earlyfw=ucode.cpio" to generate your ucode.cpio.

> You can find iucode-tool at:
> https://gitorious.org/iucode-tool/pages/Home

Thanks! That's it. I wasn't aware, that I need to convert first the microcode to binary. It's now working fine.

Cheers
Conrad

