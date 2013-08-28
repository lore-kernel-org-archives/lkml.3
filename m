Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3H1WmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:42:00 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:29998
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754993Ab3H1Wl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:41:58 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Lenny Szubowicz <lszubowi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
Thread-Topic: [PATCH 0/10] Add additional security checks when module
 loading is restricted
Thread-Index: Nz5hbGPlr11vDxoZBtCj48/bXxVZzqCFps4A
Date: Wed, 28 Aug 2013 22:41:55 +0000
Message-ID: <1377729714.27493.2.camel@x230>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
In-Reply-To: <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(199002)(189002)(377424004)(47976001)(81542001)(50986001)(4396001)(47736001)(33716001)(49866001)(46102001)(33646001)(81342001)(80022001)(65816001)(19580395003)(69226001)(77982001)(59766001)(83072001)(80976001)(83322001)(19580405001)(51856001)(74876001)(74706001)(56816003)(77096001)(79102001)(54356001)(53806001)(56776001)(74366001)(54316002)(63696002)(81686001)(81816001)(76482001)(76786001)(74662001)(47446002)(76796001)(74502001)(31966008)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B9348780CB4B84FA1F1B45A95C1B25B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7SMg5PA010413

On Wed, 2013-08-28 at 18:37 -0400, Lenny Szubowicz wrote:

> Did you purposely exclude similar checks for hibernate that were covered
> by earlier versions of your patch set?

Yes, I think it's worth tying it in with the encrypted hibernation
support. The local attack is significantly harder in the hibernation
case - in the face of unknown hardware it basically involves a
pre-generated memory image corresponding to your system or the ability
to force a reboot into an untrusted environment. I think it's probably
more workable to just add a configuration option for forcing encrypted
hibernation when secure boot is in use.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
