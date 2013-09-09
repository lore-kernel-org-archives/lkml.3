Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3IIPix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:38:53 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:31286
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761Ab3IIPiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:38:51 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Daniel Vetter <daniel@ffwll.ch>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        "Felipe Contreras" <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Topic: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Index: AQHOrTh4P2SImvKSpUu3tJlbFkAqyJm9JHkAgAAt1ACAADO4AIAABOCA
Date: Mon, 9 Sep 2013 15:38:46 +0000
Message-ID: <1378741125.17982.1.camel@x230.lan>
References: <522D88C3.7000808@intel.com> <522D89EC.6050103@intel.com>
	 <20130909093209.GF27291@phenom.ffwll.local>
	 <1793135.3qk7NfcINN@vostro.rjw.lan>
	 <20130909152118.GG27291@phenom.ffwll.local>
In-Reply-To: <20130909152118.GG27291@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(24454002)(377424004)(77096001)(63696002)(56816003)(74876001)(83072001)(76482001)(74706001)(74502001)(53806001)(47446002)(31966008)(74662001)(80976001)(54356001)(19580395003)(80022001)(83322001)(19580405001)(56776001)(54316002)(65816001)(51856001)(59766001)(77982001)(74366001)(69226001)(79102001)(46102001)(81816001)(33646001)(81686001)(49866001)(36756003)(81342001)(76796001)(76786001)(81542001)(47976001)(50986001)(4396001)(47736001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <23D000ECEB941D4EA80ED8426F386A9F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89Fcw0j020857

On Mon, 2013-09-09 at 17:21 +0200, Daniel Vetter wrote:

> If Win8 is as broken as we are I'm ok with the module option. It just
> sounded to me like right now we don't know of a way to make all machines
> somewhat happy, combined with the other pile of random backlight issues
> the assumption that we do something (maybe something a bit racy) that
> windows doesn't do isn't too far-fetched. So I'm not wary of the machines
> where the aml is busted for acpi_os=win8, but for the others where this
> broke stuff.

Windows 8 isn't broken because (as far as we can tell) the Intel drivers
under Windows 8 never use the ACPI backlight set function. Of course, it
would be nice to have that confirmed by Intel.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
