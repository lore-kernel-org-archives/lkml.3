Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaGIX1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:27:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:36275 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbaGIX1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,634,1400050800"; 
   d="scan'208";a="567615098"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: RE: [PATCH 5/6] x86-mce: check if no_way_out applies before
 deciding not to clear MCE banks.
Thread-Topic: [PATCH 5/6] x86-mce: check if no_way_out applies before
 deciding not to clear MCE banks.
Thread-Index: AQHPm5iX9ZL7m71kC0ibecR2+1ErWJuYOJZAgACYmwD//5FEQA==
Date: Wed, 9 Jul 2014 23:27:07 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32857896@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-6-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F328574C3@ORSMSX114.amr.corp.intel.com>
 <CAFQmdRb9vsWyF06jppS5U7Wzuc+SzRgWL+hs5+es-GC=5e_8qg@mail.gmail.com>
In-Reply-To: <CAFQmdRb9vsWyF06jppS5U7Wzuc+SzRgWL+hs5+es-GC=5e_8qg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s69NRH5I003614

> to run with tolerant=3, but I kind of understood the logic to be that
> if we're going to keep running, we need to clear the banks, and if
> we're going to crash, we need to leave them intact 

That makes sense ... fold some text like that into the commit
description, and this part is:

Acked-by: Tony Luck <tony.luck@intel.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
