Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaJVSIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:08:15 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:39018 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaJVSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:08:13 -0400
MIME-Version: 1.0
Date: Wed, 22 Oct 2014 16:08:13 -0200
Message-ID: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>
Subject: Regression: audit: x86: drop arch from __audit_syscall_entry() interface
From: Paulo Zanoni <przanoni@gmail.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com,
        "Signed-off-by: Eric Paris" <eparis@redhat.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

(Cc'ing everybody mentioned in the original patch)

I work for Intel, on our Linux Graphics driver - aka i915.ko - and our
QA team recently reported a regression on:

commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a
Author: Richard Guy Briggs
Date:   Tue Mar 4 10:38:06 2014 -0500
    audit: x86: drop arch from __audit_syscall_entry() interface

According to our QA, their i386 machine doesn't boot anymore. I tried
to write my own revert for the patch, asked QA to test, and they
confirmed it "solves" the problem.

Here are the details of QA' s bug report:
https://bugs.freedesktop.org/show_bug.cgi?id=85277 .

The trees our QA tests are the development trees from i915.ko:
http://cgit.freedesktop.org/drm-intel?h=drm-intel-fixes .

I tried searching for other bug reports on the same patch, but
couldn't find any. Forgive me if this bug was already reported.

Feel free to continue this discussion on the bugzilla report if you want.

Thanks,
Paulo

-- 
Paulo Zanoni
