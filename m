Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3H2THa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:07:30 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:38266
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755096Ab3H2TH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:07:29 -0400
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
Thread-Index: AQHOnPa6Tah/7plIa0O2SRc9QXB0Upmsj38AgAAG5Z2AAAVHcYAAAGWA
Date: Thu, 29 Aug 2013 19:07:26 +0000
Message-ID: <1377803245.27493.19.camel@x230>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	 <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
	 <521F9162.9060405@zytor.com> <1377801331.27493.17.camel@x230>
	 <521F9708.6040902@zytor.com> <1377802153.27493.18.camel@x230>
	 <521F9B8B.6090300@zytor.com>
In-Reply-To: <521F9B8B.6090300@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09538D3531
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(51704005)(377454003)(479174003)(377424004)(63696002)(56776001)(83072001)(54316002)(81686001)(69226001)(51856001)(74876001)(74706001)(46102001)(33646001)(53806001)(77096001)(56816003)(54356001)(76482001)(79102001)(59766001)(33716001)(81816001)(77982001)(76786001)(76796001)(80976001)(65816001)(80022001)(19580395003)(19580405001)(83322001)(49866001)(50986001)(81342001)(47976001)(47736001)(81542001)(31966008)(47446002)(74662001)(74502001)(74366001)(4396001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D4BF91FBB7B1A4DB8715F13A2B576CE@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7TJ7YoS017636

On Thu, 2013-08-29 at 12:05 -0700, H. Peter Anvin wrote:
> On 08/29/2013 11:49 AM, Matthew Garrett wrote:
> >>
> >> No, you mixed and matched in a single patch...
> > 
> > Right, but I'd fixed that in V2 (which I see I *did* send correctly, and
> > you're just replying to the old one :))
> > 
> 
> Well, I'm responding to the one that was sent 31 minutes ago.

Really? It's datestamped the 19th.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
