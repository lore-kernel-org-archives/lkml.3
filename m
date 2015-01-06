Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbbAFSAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:00:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:44569 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285AbbAFSAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:00:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,709,1413270000"; 
   d="scan'208";a="647120848"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Oleg Nesterov" <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?utf-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Subject: RE: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce
 tricks
Thread-Topic: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce
 tricks
Thread-Index: AQHQKUxotoHiYG/AiEO7foniceCOyZyzYk4w
Date: Tue, 6 Jan 2015 18:00:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com>
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
 <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
In-Reply-To: <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t06I0Jce015075

> For the context-related bits:
>
> Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Thanks.

> Should I stick this in my -next branch so it can stew?

That's fine with me.  Boris ... any comments?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
