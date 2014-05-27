Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaE0VyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:54:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:16161 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaE0Vx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,922,1392192000"; 
   d="scan'208";a="538497266"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH] x86, MCE: Flesh out when to panic comment
Thread-Topic: [PATCH] x86, MCE: Flesh out when to panic comment
Thread-Index: AQHPeMv4f2OJPRjwKESY7TWOSfRq25tTJI8AgAAETgCAAdE5YA==
Date: Tue, 27 May 2014 21:53:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3281EEA5@ORSMSX114.amr.corp.intel.com>
References: <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
 <20140521214319.GF25130@pd.tnic> <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic> <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic> <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic>
 <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
 <20140526110634.GG25732@pd.tnic>
In-Reply-To: <20140526110634.GG25732@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RLs5aX026448

>> I think the comment is still not explaining the big part of what the
>> discussion was about -- i.e. if it was in kernel context, we always
>> panic.
>
> I thought the pointer to mce_severity was enough? People should open an
> editor and look at the function and at its gory insanity. :-P

It is far from obvious that mce_severity() will always say that an error
detected inside the kernel will be fatal.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
