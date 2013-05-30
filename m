Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3E3N7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:59:07 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17049 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3E3N7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:59:02 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Topic: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Index: AQHOXL6xaJHLIdYYMUCf//A2tjAxCpkcyS2AgACME3GAAGxt8A==
Date: Thu, 30 May 2013 13:58:08 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F95D13A750@G9W0715.americas.hpqcorp.net>
References: <20130529190326.24171.86905.stgit@grignak.americas.hpqcorp.net>
 <30463843.EmBn1xaq3I@vostro.rjw.lan>
 <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
 <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
 <20130530072849.GA20793@pd.tnic>
In-Reply-To: <20130530072849.GA20793@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4UDxBut017796

> On Thu, May 30, 2013 at 04:55:20AM +0000, Ortiz, Lance E wrote:
> > This TODO is a note for future clean-up and is not directly related
> to
> >the bug being fixed with this patch. Which lends to the argument of
> why
> >put the TODO in this patch? Opportunistic. I donâ€™t think we want to
> >create a separate patch just for a TODO note.
> 
> Sounds to me, this TODO item should be on your TODO list - not in
> kernel
> sources :-)
> --
Makes sense.  I will yank the TODO and resubmit the patch.  

Lance

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
