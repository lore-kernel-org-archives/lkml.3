Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3H2StS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:49:18 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:3286
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755070Ab3H2StR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:49:17 -0400
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
Thread-Index: AQHOnPa6Tah/7plIa0O2SRc9QXB0Upmsj38AgAAG5Z2AAACXgA==
Date: Thu, 29 Aug 2013 18:49:13 +0000
Message-ID: <1377802153.27493.18.camel@x230>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	 <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
	 <521F9162.9060405@zytor.com> <1377801331.27493.17.camel@x230>
	 <521F9708.6040902@zytor.com>
In-Reply-To: <521F9708.6040902@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09538D3531
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(479174003)(199002)(189002)(377454003)(51704005)(377424004)(47976001)(81542001)(50986001)(4396001)(47736001)(49866001)(33716001)(46102001)(33646001)(81342001)(80022001)(65816001)(69226001)(19580395003)(77982001)(59766001)(83072001)(80976001)(83322001)(19580405001)(51856001)(74876001)(74706001)(56816003)(77096001)(79102001)(54356001)(53806001)(56776001)(74366001)(54316002)(63696002)(81686001)(81816001)(76482001)(76786001)(74662001)(47446002)(76796001)(74502001)(31966008)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <868D5DF701FCC142A37BC7CEB63BBC8F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7TInPTk017567

On Thu, 2013-08-29 at 11:46 -0700, H. Peter Anvin wrote:
> On 08/29/2013 11:35 AM, Matthew Garrett wrote:
> > On Thu, 2013-08-29 at 11:22 -0700, H. Peter Anvin wrote:
> >> On 08/19/2013 09:10 AM, Matthew Garrett wrote:
> >>> +	if (!capable(CAP_COMPROMISE_KERNEL))
> >>> +		return -EPERM;
> >>> +
> >>
> >> Stale bits?
> > 
> > Yeah. Did I manage to send out the old copy of that again? I'm sorry,
> > spending a few months concentrating on cloud stuff seems to have
> > entirely destroyed my ability to deal with git :(
> > 
> 
> No, you mixed and matched in a single patch...

Right, but I'd fixed that in V2 (which I see I *did* send correctly, and
you're just replying to the old one :))

> I still believe that CAP_RAWIO should be forbidden in this case.

Seems fair.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
