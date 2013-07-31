Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3GaABt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:01:49 -0400
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:48885
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756206Ab3GaABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:01:46 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        Aaron Lu <aaron.lu@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>, "Lee, Chun-Yi" <jlee@suse.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [Update][PATCH 0/3] Fix backlight issues on some Windows 8
 systems
Thread-Topic: [Update][PATCH 0/3] Fix backlight issues on some Windows 8
 systems
Thread-Index: AQHOg0uDb7STes87tEqWRuyl3H3No5l9+4OAgAAAKQA=
Date: Wed, 31 Jul 2013 00:01:41 +0000
Message-ID: <1375228900.2337.4.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1448863.3slS729B6b@vostro.rjw.lan> <3500424.KqMOhglylx@vostro.rjw.lan>
In-Reply-To: <3500424.KqMOhglylx@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:f94f:4403:b730:cc43]
x-forefront-prvs: 0924C6A0D5
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(74876001)(76482001)(77982001)(76786001)(83322001)(4396001)(74662001)(50986001)(47736001)(80976001)(59766001)(31966008)(51856001)(19580405001)(63696002)(79102001)(74706001)(80022001)(54356001)(81542001)(77096001)(69226001)(74502001)(54316002)(65816001)(19580395003)(46102001)(47976001)(47446002)(16406001)(83072001)(56816003)(53806001)(56776001)(33646001)(81342001)(49866001)(76796001)(33716001)(74366001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:f94f:4403:b730:cc43;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <75BA681935283340AB878E38E5B2061F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6V01pnK007980

On Wed, 2013-07-31 at 02:01 +0200, Rafael J. Wysocki wrote:

> (3) Fix i915 backlight control issues for all systems known to have them
>     (that may take a while) and flip the defailt for that option to set when we
>     think we're ready.

Unfortunately I don't have any systems that reproduce problems here, so
I think Intel are going to have to take the lead on this one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
