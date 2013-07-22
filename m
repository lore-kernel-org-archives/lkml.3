Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab3GVSQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:16:45 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:26370
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932264Ab3GVSQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:16:42 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Subject: Re: Linux 3.11-rc2
Thread-Topic: Linux 3.11-rc2
Thread-Index: AQHOhmdA9UA74AJ7EkSaIzxx61AakplwqpkAgABXuIA=
Date: Mon, 22 Jul 2013 18:16:20 +0000
Message-ID: <1374516979.2641.0.camel@x230>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
	 <5728692.GlhGgHY92H@vostro.rjw.lan>
In-Reply-To: <5728692.GlhGgHY92H@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.0.250.146]
x-forefront-prvs: 0915875B28
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(55674002)(377424004)(24454002)(74706001)(83322001)(59766001)(80022001)(49866001)(54316002)(66066001)(33646001)(77096001)(19580405001)(53806001)(51856001)(4396001)(76796001)(74662001)(76482001)(77982001)(56776001)(47736001)(76786001)(33716001)(50986001)(79102001)(46102001)(56816003)(65816001)(31966008)(63696002)(81542001)(74502001)(54356001)(74366001)(83072001)(47976001)(19580395003)(81342001)(74876001)(47446002)(16406001)(69226001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:50.0.250.146;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <35C799BBC128214AA041CEB2B921B856@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6MIGrPF012588

On Mon, 2013-07-22 at 15:02 +0200, Rafael J. Wysocki wrote:

> In the meantime I received a report from Steven Newbury that these changes
> broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
> The other two commits in the series should be benign.

Could you let me know the details of this problem?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
