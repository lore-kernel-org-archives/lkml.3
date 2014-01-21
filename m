Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaAUNaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:30:07 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:56545
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754354AbaAUNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:30:06 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ipc: simplify platform data approach
Thread-Topic: [PATCH 1/2] ipc: simplify platform data approach
Thread-Index: AQHO77zJAl+kPhwAkkq6qdk3g/3nHJqFGI2AgAphvoA=
Date: Tue, 21 Jan 2014 13:30:02 +0000
Message-ID: <1390311001.5320.5.camel@x230>
References: <1386030001-18348-1-git-send-email-david.a.cohen@linux.intel.com>
	 <20140114225735.GC9834@psi-dev26.jf.intel.com>
In-Reply-To: <20140114225735.GC9834@psi-dev26.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0098BA6C6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(51704005)(164054003)(24454002)(189002)(199002)(74502001)(74662001)(80022001)(87266001)(56816005)(85306002)(87936001)(90146001)(81542001)(85852003)(93516002)(74706001)(31966008)(83072002)(81342001)(86362001)(81816001)(69226001)(2656002)(74366001)(54356001)(81686001)(19580405001)(47976001)(79102001)(51856001)(77096001)(80976001)(19580395003)(83322001)(49866001)(46102001)(50986001)(4396001)(93136001)(33716001)(47736001)(92566001)(54316002)(47446002)(53806001)(33646001)(76786001)(56776001)(92726001)(77982001)(65816001)(76482001)(59766001)(74876001)(63696002)(76796001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E790673F379A9F4590C4C7B1D2A488A3@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0LDUEpA010095

On Tue, 2014-01-14 at 14:57 -0800, David Cohen wrote:
> On Mon, Dec 02, 2013 at 04:20:00PM -0800, David Cohen wrote:
> > This patch removes the unnecessary enum for platform type to handle the
> > array of pdatas. We can set pdata directly to pci_device_id struct
> > instead.
> 
> Ping. comments here? :)

These look fine. Thanks, David!

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
