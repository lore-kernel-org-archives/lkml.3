Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbaGRVtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:49:13 -0400
Received: from mail-db3lp0081.outbound.protection.outlook.com ([213.199.154.81]:48689
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751672AbaGRVtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:49:12 -0400
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "Linux (Kernel) Mailingliste" <linux-kernel@vger.kernel.org>
Subject: AW: Early microcode not being loaded
Thread-Topic: Early microcode not being loaded
Thread-Index: Ac+iyGu0bjnYxuYsRMClhSHnVLMEqQABjuOAAADRWAA=
Date: Fri, 18 Jul 2014 21:49:08 +0000
Message-ID: <4c348de3b92a49c58bf17777873410dd@DB4PR04MB265.eurprd04.prod.outlook.com>
References: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
 <20140718212427.GB11098@pd.tnic>
In-Reply-To: <20140718212427.GB11098@pd.tnic>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.218.104.196]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(199002)(51704005)(54356999)(75402002)(74482001)(107046002)(85852003)(64706001)(81542001)(106356001)(79102001)(83322001)(85306003)(76576001)(99396002)(66066001)(101416001)(74316001)(21056001)(20776003)(105586002)(46102001)(107886001)(83072002)(92566001)(229853001)(4396001)(76176999)(77982001)(81342001)(50986999)(95666004)(110136001)(74662001)(86362001)(33646002)(87936001)(2656002)(31966008)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DB4PR04MB265;H:DB4PR04MB265.eurprd04.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6ILnIdR019161

> On Fri, Jul 18, 2014 at 08:40:42PM +0000, Conrad Kostecki wrote:
> > Where is the problem? Why is the microcode not being loaded early?
> 
> CONFIG_MICROCODE_INTEL_EARLY=y set in .config?

Yes!

Galactica tmp # grep -i microcode /boot/config-3.15.5
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y

Cheers
Conrad
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
