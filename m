Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3H2Sfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:35:42 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:27229
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756928Ab3H2Sff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:35:35 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Thread-Topic: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Thread-Index: AQHOnPa6Tah/7plIa0O2SRc9QXB0Upmsj38AgAADqIA=
Date: Thu, 29 Aug 2013 18:35:32 +0000
Message-ID: <1377801331.27493.17.camel@x230>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	 <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
	 <521F9162.9060405@zytor.com>
In-Reply-To: <521F9162.9060405@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09538D3531
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(377424004)(377454003)(479174003)(65816001)(69226001)(80022001)(74366001)(74706001)(81816001)(80976001)(83072001)(19580395003)(56816003)(77096001)(83322001)(19580405001)(74876001)(81686001)(76482001)(56776001)(46102001)(54316002)(49866001)(81542001)(47736001)(47976001)(81342001)(50986001)(76786001)(76796001)(4396001)(77982001)(47446002)(59766001)(33646001)(74502001)(31966008)(79102001)(53806001)(51856001)(63696002)(54356001)(74662001)(33716001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFE8D3DD9711C04795D8A5BCCCB2A0B1@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7TIZpBw017383

On Thu, 2013-08-29 at 11:22 -0700, H. Peter Anvin wrote:
> On 08/19/2013 09:10 AM, Matthew Garrett wrote:
> > +	if (!capable(CAP_COMPROMISE_KERNEL))
> > +		return -EPERM;
> > +
> 
> Stale bits?

Yeah. Did I manage to send out the old copy of that again? I'm sorry,
spending a few months concentrating on cloud stuff seems to have
entirely destroyed my ability to deal with git :(

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
