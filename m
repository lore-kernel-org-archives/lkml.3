Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3DLVpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:45:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:37278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3DLVpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:45:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,465,1363158000"; 
   d="scan'208";a="226630056"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: RE: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
Thread-Topic: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
Thread-Index: AQHONuMqTVyUqg8MxEi8983/yrrOVpjTC5gAgAADMYCAABC44A==
Date: Fri, 12 Apr 2013 21:44:07 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1EA45A63@ORSMSX104.amr.corp.intel.com>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130412133118.GC2368@pd.tnic>
 <1365774163.9609.80.camel@gandalf.local.home>
In-Reply-To: <1365774163.9609.80.camel@gandalf.local.home>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3CLjhAr016406

> I'm not (yet). But I just wanted to make sure there wasn't any little
> subtleties that I might be missing.

I don't think there are any hidden subtleties ... if there are then they are hidden from me too.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
