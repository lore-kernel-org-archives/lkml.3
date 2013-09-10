Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3IJP5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:57:00 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:37114 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3IJP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <522F3E1D.30309@wwwdotorg.org>
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
	<CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
	<1378825549.2627.316.camel@shinybook.infradead.org>
	<CA+55aFyRUZMJiotV0kAUoeEFpFdvK2r-3rXuS7NO4jHoQ+OkPA@mail.gmail.com>
	<522F3E1D.30309@wwwdotorg.org>
Date: Tue, 10 Sep 2013 08:56:58 -0700
X-Google-Sender-Auth: uRZ0cCOAj4cX48zZ-e9q8noSSc0
Message-ID: <CA+55aFy2AqHd4=VGMaR7XsJ4z08_+AZiCeqZ8B0HB87y1NB1nA@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Kevin Hilman <khilman@linaro.org>,
        ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 8:43 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>
> x86 PCs likely have at least some of this exact same HW, e.g. I2C-based
> LM90 thermal sensors. However, I /think/ this all gets hidden from the
> OS by ACPI or other firmware mechanisms. Do you prefer firmware
> abstraction over DT?

If there was a standard one, I would actually prefer it. Just not the
insanity of ACPI with pseudo-executable code, just plain read-only
tables. The fact that there isn't any unification in the ARM market
makes bad design decisions _worse_.

So yes, the same mess exists on PC's too (sound in particular tends to
be a morass of just basically crazy "this is wired up so-and-so"), but
on PCs you end up having the advantage of (a) more stuff is
discoverable and (b) a long-time standard platform so the stuff that
isn't is much less bad. ARM doesn't have that (and it's basically
impossible to create a standard in that space), and as a result
absolutely _everything_ is one-off, which just exacerbates the
problem.

               Linus
