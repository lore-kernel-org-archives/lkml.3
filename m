Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3FJNsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:48:10 -0400
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:35509
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616Ab3FJNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:48:08 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Thread-Topic: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Thread-Index: AQHOZdCy0C608TgzZU6JwZlMJ4ewq5ku9p+A
Date: Mon, 10 Jun 2013 13:48:04 +0000
Message-ID: <1370872083.9178.2.camel@x230.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1714928.Kf7sBtKE1o@vostro.rjw.lan>
In-Reply-To: <1714928.Kf7sBtKE1o@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5D0396D51E1A14194A5994F95A8B5B9@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5ADmGYZ004751

On Mon, 2013-06-10 at 13:59 +0200, Rafael J. Wysocki wrote:

> I happen to know that alternative solution to this problem is being worked on,
> so I'm going to wait until it is submitted and then we'll decide what to merge.

Sure.

> I'm slightly concerned about unregistering ACPI backlight control for all
> systems declaring win8 support, even though it may actually work for them.

Right, that's why I think it's correct to leave it up to the graphics
drivers. It seems like they're the ones that make the policy
determination under Windows now. The policy as implemented here may not
be correct, but doing better would probably involve Intel letting us
know how their Windows driver behaves.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
