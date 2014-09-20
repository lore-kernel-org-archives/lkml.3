Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaITPhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 11:37:12 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:18553
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbaITPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 11:37:10 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Scott Wood <scottwood@freescale.com>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAHB1gIAA7qUAgAAQKlCAACO3gIAAAkGAgAACgoCAABIZAIABKEfA
Date: Sat, 20 Sep 2014 15:36:59 +0000
Message-ID: <b0d1eee4a8684153baac4f2aea099fa4@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <541A5CF1.8000409@freescale.com>
	 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	 <20140918152233.41647ee517393816bb35b72a@freescale.com>
	 <541B9D5F.20008@freescale.com>
	 <20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
	 <3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
	 <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
	 <541C92F9.1020805@suse.de> <1411159315.13320.81.camel@snotra.buserror.net>
 <541CA442.5080201@suse.de>
In-Reply-To: <541CA442.5080201@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(86362001)(90102001)(85306004)(106356001)(76576001)(83072002)(15975445006)(108616004)(101416001)(74316001)(77096002)(46102003)(15202345003)(93886004)(2656002)(64706001)(79102003)(77982003)(107046002)(4396001)(19580395003)(31966008)(87936001)(81342003)(99396002)(54356999)(95666004)(74502003)(105586002)(50986999)(33646002)(81542003)(76482002)(80022003)(92566001)(99286002)(20776003)(106116001)(66066001)(76176999)(74662003)(21056001)(85852003)(83322001)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0714;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8KFbbjx021464

> Speaking of which, how does Linux find this new bus? I couldn't find
> anything that describes the device tree bindings, but maybe I just
> missed them.

There is a separate thread on the ARM mailing list with the device tree
and binding (device tree will be in arch/arm64):

http://www.spinics.net/lists/arm-kernel/msg354635.html

Stuart
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
