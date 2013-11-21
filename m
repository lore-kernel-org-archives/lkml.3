Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3KUBrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:47:20 -0500
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:50181
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab3KUBrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:47:18 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "sathyanarayanan.kuppuswamy@linux.intel.com" 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>,
        "eric.ernst@linux.intel.com" <eric.ernst@linux.intel.com>
Subject: Re: [PATCH v2.2] ipc: Added support for IPC interrupt mode
Thread-Topic: [PATCH v2.2] ipc: Added support for IPC interrupt mode
Thread-Index: AQHO5ltzUVG6MVsg00SrGM0fo74ZfJou6noA
Date: Thu, 21 Nov 2013 01:47:12 +0000
Message-ID: <1384998432.20536.14.camel@x230>
References: <1384561314-11210-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1384998333-141121-1-git-send-email-sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1384998333-141121-1-git-send-email-sathyanarayanan.kuppuswamy@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(377424004)(199002)(24454002)(164054003)(76786001)(80976001)(2656002)(76796001)(51856001)(77096001)(50986001)(54356001)(85306002)(46102001)(47976001)(49866001)(4396001)(47736001)(53806001)(65816001)(74706001)(69226001)(81542001)(87936001)(81686001)(33646001)(33716001)(74502001)(81342001)(87266001)(19580405001)(83322001)(81816001)(19580395003)(76482001)(74876001)(80022001)(56776001)(56816003)(47446002)(31966008)(74662001)(74366001)(59766001)(83072001)(79102001)(54316002)(77982001)(63696002)(558084003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCC22E0F8C64F040BF2D53D0FF37C050@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAL1lOl1014109

On Wed, 2013-11-20 at 17:45 -0800, Kuppuswamy Sathyanarayanan wrote:

>  - Changed INIT_COMPLETION to reinit_completion.

Thanks, I've already folded that fix into the patch and re-pushed.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
