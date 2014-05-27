Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaE0OJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:09:16 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:23636
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbaE0OJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:09:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v3 00/15] Thunderbolt driver for Apple MacBooks
Thread-Topic: [PATCH v3 00/15] Thunderbolt driver for Apple MacBooks
Thread-Index: AQHPebU7LaSLwZwcJkCtZFLwBcwgow==
Date: Tue, 27 May 2014 14:09:10 +0000
Message-ID: <1401199750.7663.3.camel@x230>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
In-Reply-To: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(4396001)(33646001)(99286001)(99396002)(21056001)(33716001)(92566001)(83072002)(81542001)(85852003)(81342001)(19580395003)(76482001)(558084003)(54356999)(64706001)(74502001)(50986999)(31966008)(80022001)(74662001)(86362001)(76176999)(20776003)(101416001)(92726001)(46102001)(19580405001)(83322001)(87936001)(103116003)(77982001)(79102001)(2656002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5A445DABCADE94B8AF158658F89DF75@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RE9OW9023216

Adding the PCI IDs for the Thunderbolt 2 device in the Mac Pro seems to
work, with the possible exception of hotplug - I'll look into that some
more. I also have a new set of the ACPI patches, which I'll try to send
out today.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
