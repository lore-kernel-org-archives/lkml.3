Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaDAWYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:24:45 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:1932
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbaDAWYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:24:43 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "mario_limonciello@dell.com" <mario_limonciello@dell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH v5 0/1] Add WMI driver to control AlienFX features
Thread-Topic: [PATCH v5 0/1] Add WMI driver to control AlienFX features
Thread-Index: AQHPSPtm1IntBEQGwkSnbZfVhMtL7Jr9XoQAgAAB3QA=
Date: Tue, 1 Apr 2014 22:24:40 +0000
Message-ID: <1396391080.2824.0.camel@x230>
References: <1395842248-27868-1-git-send-email-mario_limonciello@dell.com>
	 <533B3B18.1030000@dell.com>
In-Reply-To: <533B3B18.1030000@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(199002)(24454002)(51704005)(189002)(20776003)(69226001)(63696002)(54316002)(99286001)(56776001)(65816001)(83072002)(87936001)(56816005)(74502001)(81686001)(83322001)(74706001)(59766001)(93136001)(47446002)(19580395003)(54356001)(19580405001)(93516002)(79102001)(74366001)(92726001)(92566001)(77982001)(90146001)(53806001)(99396002)(47736001)(31966008)(76482001)(33716001)(80022001)(86362001)(46102001)(85306002)(74876001)(87266001)(80976001)(81816001)(33646001)(81542001)(4396001)(77096001)(94316002)(81342001)(94946001)(49866001)(47976001)(74662001)(51856001)(50986001)(97336001)(76786001)(97186001)(2656002)(76796001)(95666003)(98676001)(85852003)(95416001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:D019B8A5.BE70C509.7174A5A9.D4C3CD30.200D2;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <13DD1B188BB4D5469B53FB89B1E55BB4@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s31MOnW1007271

On Tue, 2014-04-01 at 17:18 -0500, Mario Limonciello wrote:

> Matthew,
> 
> Any feedback to apply on this?

I think this approach (not overloading the brightness attribute) is a
much better one, thanks. I have this queued, I'll send Linus a PR in a
couple of days once I've sorted out a couple of unrelated things.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
