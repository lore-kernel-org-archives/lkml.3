Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab3GZVg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:36:57 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:53454 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161015Ab3GZVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <51F2D9D2.8050405@zytor.com>
References: <tip-eaa5a990191d204ba0f9d35dbe5505ec2cdd1460@git.kernel.org>
	<51F2D9D2.8050405@zytor.com>
Date: Fri, 26 Jul 2013 14:36:51 -0700
X-Google-Sender-Auth: kLKlnjwQbMIzFxIHhiiJBpNELG4
Message-ID: <CA+55aFzVj4YnUMik_BYbSab7PeL=__fPO47FTUAdY2090Yyapg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, fpu: correct the asm constraints for fxsave
 , unbreak mxcsr.daz
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-stable <stable@vger.kernel.org>, Peter Anvin <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "tip-bot for H.J. Lu" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 1:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> The bug is obvious; the fix at the very least *should* be obvious; the
> main source of risk would appear that it might trigger bugs in very old
> versions of gcc.

I used to be worried about "+m", but we're using it a lot these days,
and don't support the (really old) versions of gcc that used to have
trouble with in-out constraints. So the fix looks obvious and safe, no
worries from me.

          Linus
