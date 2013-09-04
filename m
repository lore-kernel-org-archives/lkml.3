Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740Ab3IDBmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:42:19 -0400
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:16072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761645Ab3IDBmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:42:17 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: James Morris <jmorris@namei.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Thread-Topic: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Thread-Index: AQHOqQOEKX11AlwUCUWI4DFZZ3VWp5m0zgeA////5IA=
Date: Wed, 4 Sep 2013 01:42:12 +0000
Message-ID: <1378258931.11730.49.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1309041142080.20116@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1309041142080.20116@tundra.namei.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(51704005)(80022001)(81686001)(79102001)(59766001)(77982001)(33716001)(65816001)(63696002)(80976001)(54316002)(56776001)(69226001)(77096001)(76482001)(54356001)(53806001)(76786001)(33646001)(76796001)(81816001)(56816003)(81342001)(47736001)(4396001)(74706001)(31966008)(81542001)(49866001)(74876001)(74662001)(50986001)(47976001)(74502001)(47446002)(83072001)(74366001)(46102001)(19580405001)(83322001)(51856001)(19580395003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F2D0CE854AD39468701B7DD872215B4@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r841gPSE018748

On Wed, 2013-09-04 at 11:42 +1000, James Morris wrote:
> On Tue, 3 Sep 2013, Matthew Garrett wrote:
> 
> > +	status = efi_call_phys5(sys_table->runtime->get_variable,
> > +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> > +
> 
> 
> What's 'L' ?

Wide-character string constant. UEFI variable names are 16-bits per
character.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
