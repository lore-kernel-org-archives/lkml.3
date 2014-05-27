Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaE0OW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:22:28 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:31751
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbaE0OW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:22:26 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v3 13/15] pci: Suspend/resume quirks for appel
 thunderbolt
Thread-Topic: [PATCH v3 13/15] pci: Suspend/resume quirks for appel
 thunderbolt
Thread-Index: AQHPePXFOYZ3T9Kkn0eGpWsq5nOPg5tUeAkA
Date: Tue, 27 May 2014 14:07:22 +0000
Message-ID: <1401199642.7663.1.camel@x230>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
	 <1401117492-2870-14-git-send-email-andreas.noever@gmail.com>
In-Reply-To: <1401117492-2870-14-git-send-email-andreas.noever@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(24454002)(377424004)(76482001)(76176999)(4396001)(86362001)(54356999)(103116003)(33646001)(33716001)(46102001)(77982001)(99396002)(87936001)(80022001)(2656002)(74502001)(83072002)(85852003)(92726001)(81542001)(50986999)(21056001)(101416001)(20776003)(92566001)(99286001)(19580405001)(79102001)(74662001)(64706001)(81342001)(83322001)(31966008)(19580395003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B2725F238F7E74BAAFF5A09A2E75B4B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4REMccE023321

On Mon, 2014-05-26 at 17:18 +0200, Andreas Noever wrote:
> Add two quirks to support thunderbolt suspend/resume on apple systems.
> We need to perform two different actions during suspend and resume:

It seems like we ought to be able to do this with a power domain, rather
than having to add code to the PCI core? I've got an implementation that
currently fails for reasons I haven't debugged, I'll see if I can get it
working today.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
