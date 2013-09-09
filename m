Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3IIRYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:24:23 -0400
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:56280
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab3IIRYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:24:21 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Topic: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9p86A
Date: Mon, 9 Sep 2013 17:24:16 +0000
Message-ID: <1378747455.17982.9.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
In-Reply-To: <19562.1378747124@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(51856001)(59766001)(56776001)(19580405001)(54316002)(83322001)(80022001)(65816001)(81342001)(76796001)(36756003)(49866001)(4396001)(47736001)(81542001)(47976001)(76786001)(50986001)(79102001)(46102001)(74366001)(77982001)(69226001)(33646001)(81686001)(81816001)(19580395003)(63696002)(56816003)(77096001)(83072001)(74876001)(80976001)(54356001)(74502001)(53806001)(47446002)(74662001)(31966008)(76482001)(74706001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <83F8CDDAF8C01943842B217E2D87E853@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89HOR1w021744

On Mon, 2013-09-09 at 13:18 -0400, Valdis.Kletnieks@vt.edu wrote:

> You may as well bite the bullet on this one, and tie it together.  Without
> Secure Boot, by the time your code runs it's already too late.  That's the
> whole point of Secure Boot, after all.

It's already been made clear that nobody's interested in merging a
solution that's specific to Secure Boot. I can add a command line option
to set a default, and then anyone using an attesting bootloader
(TPM/TXT) can verify the state.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
