Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3ILTOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:14:00 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34458 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3ILTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130912191213.GB11400@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<20130912184341.GA11400@ghostprotocols.net>
	<20130912191213.GB11400@ghostprotocols.net>
Date: Thu, 12 Sep 2013 12:13:57 -0700
X-Google-Sender-Auth: EiMgbdNzBbrbmfY3cktb2l7Mgd0
Message-ID: <CA+55aFzPHg-zEO1s-xyxePSbQ5HrQxK-HjMOgyLjwhXkKbNyJg@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:12 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
>
> We probably got all this from the 'git' makefile, checking how it is done
> there these days...

I suspect it's the same.

The thing I was really complaining about is how slow "make install"
is, since it seems to redo most everything I already did...

           Linus
