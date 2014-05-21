Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaEUXkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:40:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:28602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbaEUXke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:40:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,883,1392192000"; 
   d="scan'208";a="544560799"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: RE: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Topic: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Index: AQHPdT5wRvlmui20OUO5csd5VXpJ+ZtMCOaA//+MFSCAAHmbAP//i7GAgAB3ZAD//4s2oAAPHlmAAABRNgAADkH6oP//k0EAgABy/7D//5OAgIAAc9mQ
Date: Wed, 21 May 2014 23:40:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32811CE2@ORSMSX114.amr.corp.intel.com>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
	<CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
	<20140521214845.GG25130@pd.tnic>
	<CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
	<CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
	<CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
	<CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
	<20140521224816.GP25130@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
	<CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
 <CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com>
In-Reply-To: <CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LNejHo023098

> MCE is frankly misdesigned. It's a piece of shit, and any of the
> hardware designers that claim that what they do is for system
> stability are out to lunch. This is a prime example of what *NOT* to
> do, and how you can actually spread what was potentially a localized
> and recoverable error, and make it global and unrecoverable.

Latest SDM (version 050 from late February this year) describes how
this is going to be fixed. Recoverable machine checks are going to be
thread local. But current silicon still has the broadcast behavior ...
silicon development pipeline is very long :-(

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
