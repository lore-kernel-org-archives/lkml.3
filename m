Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaHKQZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:25:53 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:43838
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754390AbaHKQZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:25:52 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Jose Rivera <German.Rivera@freescale.com>
Subject: location for new bus driver-- drivers/bus? drivers/misc?
Thread-Topic: location for new bus driver-- drivers/bus? drivers/misc?
Thread-Index: Ac+1gOjK8cjTvEg1Sy29tqG4s2ri6A==
Date: Mon, 11 Aug 2014 16:25:49 +0000
Message-ID: <9953b08b77224e738a1a1672dcf209c5@BY2PR0301MB0743.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03008837BD
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(199002)(189002)(86362001)(81542001)(101416001)(54356999)(77096002)(83322001)(99396002)(50986999)(81342001)(74316001)(4396001)(99286002)(95666004)(74502001)(46102001)(76482001)(31966008)(92566001)(85306004)(64706001)(20776003)(21056001)(80022001)(66066001)(76576001)(74662001)(85852003)(79102001)(110136001)(87936001)(2656002)(2351001)(107046002)(33646002)(105586002)(229853001)(106356001)(83072002)(77982001)(2501001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB332;H:BY2PR0301MB0743.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

We (Freescale) have a patch series nearly ready to send out
for a new bus driver.  It's for a block we call the Freescale
'Management Complex' which manages discoverable hardware objects.
The Linux bus driver enumerates these objects, binds discovered
objects to drivers just like PCI or any normal bus driver.

Question is-- where should this go in the kernel and who would
the maintainer be to cc: the RFC?  I don't think it warrants
a top level driver directory beside pci, usb, etc.  Most likely
place is drivers/bus or drivers/misc (?).

We currently have it in drivers/bus, but as far as I can see
there is no maintainer per se for that directory.  You and 
Arnd manage misc so thought I would ask.

Thanks,
Stuart
