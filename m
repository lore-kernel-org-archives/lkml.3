Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaGGQCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:02:35 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:56265
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751077AbaGGQCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:02:33 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "vidyas@nvidia.com" <vidyas@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kthota@nvidia.com" <kthota@nvidia.com>,
        "nagananda.chumbalkar@hp.com" <nagananda.chumbalkar@hp.com>
Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Thread-Topic: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Thread-Index: AQHPmIMAqTeUUacDIUKmSpwIfKBBfZuR1jCAgALyfQA=
Date: Mon, 7 Jul 2014 16:02:29 +0000
Message-ID: <1404748948.9762.29.camel@x230>
References: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
	 <20140705185736.GD28871@google.com> <20140705190203.GE28871@google.com>
In-Reply-To: <20140705190203.GE28871@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(35774003)(24454002)(377424004)(51704005)(189002)(199002)(74502001)(99396002)(103116003)(16601075003)(33716001)(33646001)(77982001)(99286002)(46102001)(79102001)(50986999)(77096002)(106116001)(15202345003)(110136001)(95666004)(31966008)(105586002)(106356001)(74662001)(2351001)(107046002)(85306003)(4396001)(87936001)(92566001)(19580395003)(19580405001)(83322001)(83072002)(85852003)(20776003)(21056001)(101416001)(86362001)(76482001)(54356999)(81542001)(2656002)(92726001)(76176999)(64706001)(80022001)(15975445006)(81342001)(3826002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <51D6E4DAF6B1794AA2E800A287F3ECAE@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s67G2eDn003955

On Sat, 2014-07-05 at 13:02 -0600, Bjorn Helgaas wrote:
> > Rafael, Matthew, any comments?  We have vacillated on this before and
> > the web is already pretty tangled.
> > 
> > Vidya, can you give more details about the bug fixed by this change?
> > What's the scenario?  Are we resuming and the device is powered up but
> > ASPM isn't enabled?  Maybe you could collect more details in a
> > http://bugzilla.kernel.org report?

I believe that's the case. The proposed change would fix it but isn't
really terribly clean - I think it would be more readable to split this
into multiple functions.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
