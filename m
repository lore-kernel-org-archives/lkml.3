Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab3GWTwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:52:02 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:33717
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933930Ab3GWTv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:51:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Steven Newbury <steve@snewbury.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Thread-Topic: Linux 3.11-rc2
Thread-Index: AQHOhmdA9UA74AJ7EkSaIzxx61AakplwqpkAgABXuICAABvsgIABbnmAgAAio4A=
Date: Tue, 23 Jul 2013 19:51:54 +0000
Message-ID: <1374609113.2641.2.camel@x230>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <5728692.GlhGgHY92H@vostro.rjw.lan> <1374516979.2641.0.camel@x230>
	 <1943327.gJaLv781Zb@vostro.rjw.lan> <1374601675.29964.15.camel@artifact>
In-Reply-To: <1374601675.29964.15.camel@artifact>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [207.225.82.209]
x-forefront-prvs: 0916FC3A18
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(24454002)(377424004)(74876001)(69226001)(54356001)(77096001)(33646001)(81542001)(56776001)(46102001)(76786001)(81342001)(53806001)(33716001)(54316002)(76796001)(56816003)(16406001)(80022001)(47446002)(83072001)(19580395003)(74366001)(65816001)(74662001)(63696002)(83322001)(31966008)(19580405001)(74502001)(50986001)(47736001)(74706001)(47976001)(49866001)(77982001)(66066001)(76482001)(4396001)(59766001)(79102001)(51856001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:207.225.82.209;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0BFE3F5A1902B4E8EA4563F717ED5B4@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6NJqaN2021617

On Tue, 2013-07-23 at 18:47 +0100, Steven Newbury wrote:

> In the code as was present in the linux-pm/bleeding-edge tree I would
> encounter a hard lockup on keyboard brightness trigger.  This also occurred with
> the code as it initially hit mainline, but a later commit fixed the crash*, but
> resulted in no backlight controls being available at all.
> /sys/class/backlight  is empty.

This is an Intel system using the i915 driver?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
