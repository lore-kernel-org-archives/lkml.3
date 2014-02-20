Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaBTUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:16:27 -0500
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:51747
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752516AbaBTUQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:16:25 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAAY4A=
Date: Thu, 20 Feb 2014 20:16:22 +0000
Message-ID: <1392927381.20109.0.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com>
In-Reply-To: <20140220201458.GA7099@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(199002)(189002)(24454002)(80976001)(47976001)(76786001)(85306002)(77982001)(46102001)(47446002)(86362001)(87936001)(49866001)(81542001)(4396001)(95666003)(92726001)(87266001)(19580405001)(83322001)(69226001)(31966008)(81342001)(74662001)(74502001)(33716001)(74366001)(19580395003)(85852003)(51856001)(93136001)(56816005)(92566001)(65816001)(90146001)(80022001)(94316002)(63696002)(76482001)(77096001)(54316002)(2656002)(76796001)(47736001)(50986001)(79102001)(33646001)(59766001)(83072002)(93516002)(54356001)(53806001)(74706001)(95416001)(56776001)(81816001)(94946001)(81686001)(74876001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:F50F0ED.18128C2B.2D70954E.84E2BA79.20105;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <03BC048BC73B2748AE00745B7268741B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KKGVwk021249

On Thu, 2014-02-20 at 14:14 -0600, Russ Anderson wrote:

> The distro that added this change created all sorts of support
> problems.  Problems include kipmi0 spinning at 100% of cpu
> (creating a performance hit) and long boot delays (as the
> kernel tries to talk to a BMC that will never respond).
> It has been a big mess.

Why is the BMC not responding? Why is kipmi0 at 100%? Why are we not
fixing those bugs?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
