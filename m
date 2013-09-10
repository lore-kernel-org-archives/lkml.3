Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3IJN64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:58:56 -0400
Received: from [207.46.163.242] ([207.46.163.242]:2949 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750974Ab3IJN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:58:54 -0400
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
Thread-Index: AQHOrTh4P2SImvKSpUu3tJlbFkAqyJm9JHkAgAAt1ACAADO4AIAAVGuAgAElbgCAAADpAA==
Date: Tue, 10 Sep 2013 13:56:59 +0000
Message-ID: <1378821416.17982.56.camel@x230.lan>
References: <522D88C3.7000808@intel.com> <1793135.3qk7NfcINN@vostro.rjw.lan>
	 <20130909152118.GG27291@phenom.ffwll.local>
	 <5155010.Y1gov7SKhP@vostro.rjw.lan> <87eh8wail7.fsf@intel.com>
In-Reply-To: <87eh8wail7.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(24454002)(377424004)(77096001)(74876001)(83072001)(47446002)(76482001)(74706001)(74502001)(80976001)(63696002)(53806001)(74662001)(31966008)(54356001)(56816003)(83322001)(19580405001)(56776001)(54316002)(65816001)(51856001)(81342001)(59766001)(76796001)(36756003)(81686001)(33646001)(74366001)(77982001)(69226001)(19580395003)(80022001)(81816001)(4396001)(49866001)(47736001)(79102001)(46102001)(76786001)(47976001)(81542001)(50986001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B5F574CAF8E414F94F0B151F7A40CD3@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8ADx2QB028271

On Tue, 2013-09-10 at 16:53 +0300, Jani Nikula wrote:

> I think the parameter "Does the ACPI backlight interface work or not"
> belongs to the ACPI video driver.

That depends on how Windows 8 works. If Windows 8 policy is handled by
the GPU drivers then it belongs in i915. If it's handled by the ACPI
code then it belongs in the ACPI code. But I have no way of determining
that, whereas you work for a company that produces a Windows 8 video
driverâ€¦

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
