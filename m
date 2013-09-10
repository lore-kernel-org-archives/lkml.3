Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3IJOVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:21:34 -0400
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:11242
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab3IJOVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:21:31 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Vetter <daniel@ffwll.ch>,
        "Aaron Lu" <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Topic: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Index: AQHOrTh4P2SImvKSpUu3tJlbFkAqyJm9JHkAgAAt1ACAADO4AIAAVGuAgAElbgCAAAddTIAAAGUA
Date: Tue, 10 Sep 2013 14:21:26 +0000
Message-ID: <1378822886.17982.58.camel@x230.lan>
References: <522D88C3.7000808@intel.com> <1793135.3qk7NfcINN@vostro.rjw.lan>
	 <20130909152118.GG27291@phenom.ffwll.local>
	 <5155010.Y1gov7SKhP@vostro.rjw.lan> <87eh8wail7.fsf@intel.com>
	 <1378821416.17982.56.camel@x230.lan> <87bo40ahai.fsf@intel.com>
In-Reply-To: <87bo40ahai.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(51704005)(199002)(189002)(80022001)(81816001)(76786001)(47736001)(69226001)(65816001)(81342001)(46102001)(33646001)(81686001)(49866001)(47976001)(50986001)(79102001)(4396001)(81542001)(76796001)(36756003)(31966008)(74366001)(74706001)(74502001)(74662001)(47446002)(63696002)(80976001)(74876001)(59766001)(19580395003)(83072001)(83322001)(19580405001)(76482001)(54316002)(77982001)(56816003)(56776001)(53806001)(77096001)(54356001)(51856001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <62D4E6A79A5F774797259796F61596A6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8AELdEa028456

On Tue, 2013-09-10 at 17:21 +0300, Jani Nikula wrote:
> On Tue, 10 Sep 2013, Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > On Tue, 2013-09-10 at 16:53 +0300, Jani Nikula wrote:
> >
> >> I think the parameter "Does the ACPI backlight interface work or not"
> >> belongs to the ACPI video driver.
> >
> > That depends on how Windows 8 works. If Windows 8 policy is handled by
> > the GPU drivers then it belongs in i915. If it's handled by the ACPI
> > code then it belongs in the ACPI code.
> 
> I fail to see the logic. Windows 8 policy dictates whether we can use
> the AML code or not. IMHO, ACPI code is in the best position to figure
> this out and quirk as necessary. It's the part that knows about Windows
> 8, not i915.

So if nvidia hardware uses the ACPI interface and Intel doesn't, we
should still quirk it in the ACPI driver?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
