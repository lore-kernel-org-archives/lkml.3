Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3I2UvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:51:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34626 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3I2Uu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:50:59 -0400
Date: Sun, 29 Sep 2013 22:50:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer AMD
 processors
Message-ID: <20130929205051.GD5426@pd.tnic>
References: <52486938.4090009@gmail.com>
 <20130929180101.GB5490@pd.tnic>
 <5248905E.8000801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5248905E.8000801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 04:41:02PM -0400, Austin S Hemmelgarn wrote:
> While I understand that you want decisive proof that it provides an
> improvement, does it specifically matter if the option is unused by
> most people and doesn't result in a negative performance hit when
> used?

Just having the option for no good reason at all is a no-no.

> I will, however, do some intensive profiling over the next week and
> get back to you about exact improvements. Just in the past few days of
> using it, I have noticed much better response time in time sensitive
> user-space code (mostly emulators and multimedia apps).

Yes, we need concrete benchmark numbers from a kernel built with MK8
or even GENERIC vs one built with those new options, most likely
with the one for the box you'll be running the benchmarks on. And no
microbenchmarks please.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
