Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaDDSTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:19:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56767 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaDDST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140404162108.GA17393@srcf.ucam.org>
References: <20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
	<20140403194018.7c67aec7@gandalf.local.home>
	<533DF455.4040908@linux.intel.com>
	<533DF8D2.9060508@zytor.com>
	<533E0A94.5040007@linux.intel.com>
	<20140404151203.GA12370@srcf.ucam.org>
	<CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
	<20140404154520.GA14980@srcf.ucam.org>
	<CA+55aFwiO2kcNF4=ph9UWhPB7Vd6sRZ5B6g7qFV2yAwKBLP+2Q@mail.gmail.com>
	<20140404162108.GA17393@srcf.ucam.org>
Date: Fri, 4 Apr 2014 11:19:26 -0700
X-Google-Sender-Auth: JflZECSKn349ycBmiTcsEur5xAI
Message-ID: <CA+55aFzbBYV=R+7HJXMRL0+E8rgvHt0cFXoh++Y9716Yv_9Xfw@mail.gmail.com>
Subject: Re: [BUG] x86: reboot doesn't reboot
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 9:21 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Because Windows doesn't use CF9 but machines reboot anyway. That
> shouldn't be a controversial point of view.

No, that's not a controversial view.

But it's not the case for us, and I haven't seen a patch to make us
work more like Windows, so for *us*, and in this universe (rather than
some make-believe one), the fact that we need to use pci to reboot is
simply a fact. Including, very much, on "production hardware".

So I repeat: I'd love to fix whatever it is that we do that is
different and triggers problems (particularly on Dell, but there are
certainly other vendors too). But in the absense of that (and I
haven't actually seen a serious patch for it), denying that reboot=pci
is sometimes the right thing - regardless of "production" hardware or
not is not valid. That's what I reacted to.

               Linus
