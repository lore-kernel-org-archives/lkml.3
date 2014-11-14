Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbaKNWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:25:57 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:53212 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422637AbaKNWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:25:56 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 14:25:34 -0800
Message-ID: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
Subject: Request for help: what did I do wrong with idtentry?
To: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/paranoid&id=5b58c7ac3034a8d62e42a6ca91c7a95e887542e7

which is functionally identical to:

http://lkml.kernel.org/g/76efedcd3622e61feb2982eabe52a6bf531396a9.1415917623.git.luto@amacapital.net

causes Tony's MCE stress test to fail, presumably when some CPU either
becomes permanently non-interruptable or otherwise wanders off into
the weeds.

Could any of you take a quick look and see if anything stands out?
I'm a bit stuck, since I don't have hardware that can run the stress
test, and I can't reproduce any problems with this patch at all.

Thanks,
Andy
