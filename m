Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaJVSXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbaJVSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:23:37 -0400
Message-ID: <1414002190.30946.95.camel@localhost>
Subject: Re: Regression: audit: x86: drop arch from __audit_syscall_entry()
 interface
From: Eric Paris <eparis@redhat.com>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 22 Oct 2014 14:23:10 -0400
In-Reply-To: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>
References: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's really serious.  Looking now.

On Wed, 2014-10-22 at 16:08 -0200, Paulo Zanoni wrote:
> Hi
> 
> (Cc'ing everybody mentioned in the original patch)
> 
> I work for Intel, on our Linux Graphics driver - aka i915.ko - and our
> QA team recently reported a regression on:
> 
> commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a
> Author: Richard Guy Briggs
> Date:   Tue Mar 4 10:38:06 2014 -0500
>     audit: x86: drop arch from __audit_syscall_entry() interface
> 
> According to our QA, their i386 machine doesn't boot anymore. I tried
> to write my own revert for the patch, asked QA to test, and they
> confirmed it "solves" the problem.
> 
> Here are the details of QA' s bug report:
> https://bugs.freedesktop.org/show_bug.cgi?id=85277 .
> 
> The trees our QA tests are the development trees from i915.ko:
> http://cgit.freedesktop.org/drm-intel?h=drm-intel-fixes .
> 
> I tried searching for other bug reports on the same patch, but
> couldn't find any. Forgive me if this bug was already reported.
> 
> Feel free to continue this discussion on the bugzilla report if you want.
> 
> Thanks,
> Paulo
> 


