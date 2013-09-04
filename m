Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3IDUMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:12:48 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:9187
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932888Ab3IDUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:12:15 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "jerry.hoemann@hp.com" <jerry.hoemann@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>, kexec <kexec@lists.infradead.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Topic: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm2A3WAgAAAm4A=
Date: Wed, 4 Sep 2013 20:12:09 +0000
Message-ID: <1378325529.13193.8.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130904200959.GE8540@anatevka.fc.hp.com>
In-Reply-To: <20130904200959.GE8540@anatevka.fc.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(377424004)(51704005)(24454002)(74706001)(19580405001)(83322001)(56816003)(77096001)(47446002)(31966008)(74502001)(74662001)(74366001)(19580395003)(53806001)(80976001)(69226001)(76796001)(76786001)(33646001)(81816001)(65816001)(81686001)(66066001)(33716001)(83072001)(80022001)(51856001)(4396001)(59766001)(77982001)(46102001)(76482001)(54356001)(74876001)(56776001)(63696002)(54316002)(81542001)(79102001)(81342001)(47736001)(49866001)(47976001)(50986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <72C1C6130164D64EA8A958B3BA00E179@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84KCrXj025528

On Wed, 2013-09-04 at 14:09 -0600, jerry.hoemann@hp.com wrote:
> On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
> > kexec permits the loading and execution of arbitrary code in ring 0, which
> > is something that module signing enforcement is meant to prevent. It makes
> > sense to disable kexec in this situation.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> 
> 
> Matthew,
> 
> Disabling kexec will disable kdump, correct?

Yes.

> Are there plans to enable kdump on a system where secure
> boot is enabled?

Yes, Vivek Goyal (cc:ed) is working on that.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
