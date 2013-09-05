Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3IEMyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:54:47 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:29889
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753852Ab3IEMyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:54:45 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Thread-Topic: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Thread-Index: AQHOqQOEKX11AlwUCUWI4DFZZ3VWp5m28AmAgAAsHIA=
Date: Thu, 5 Sep 2013 12:54:41 +0000
Message-ID: <1378385681.13193.27.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
	 <20130905101649.GL28598@console-pimps.org>
In-Reply-To: <20130905101649.GL28598@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(377424004)(33716001)(76786001)(76796001)(74662001)(47446002)(74502001)(77982001)(59766001)(79102001)(54356001)(81686001)(33646001)(74706001)(66066001)(65816001)(74876001)(80022001)(77096001)(56816003)(69226001)(31966008)(558084003)(19580395003)(74366001)(4396001)(81542001)(50986001)(47976001)(63696002)(83072001)(46102001)(51856001)(80976001)(56776001)(81816001)(76482001)(54316002)(53806001)(49866001)(47736001)(81342001)(83322001)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D1C7A1BEB22EC47830CE2AE76670FAA@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r85CspwI030299

On Thu, 2013-09-05 at 11:16 +0100, Matt Fleming wrote:

> I'd advise checking efi_enabled(EFI_BOOT) along with .secure_boot to
> guard against garbage values in boot_params.

We've called sanitize_boot_params(), so we can assert that there are no
garbage values.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
