Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3GXHkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:40:20 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:60749 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3GXHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:40:18 -0400
Date: Wed, 24 Jul 2013 03:39:49 -0400
From: Rich Felker <dalias@aerifal.cx>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Hogan <james.hogan@imgtec.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
Message-ID: <20130724073948.GS3249@brightrain.aerifal.cx>
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com>
 <20130724055518.GQ3249@brightrain.aerifal.cx>
 <51EF78BB.8000503@monstr.eu>
 <20130724065957.GR3249@brightrain.aerifal.cx>
 <51EF7F33.8020305@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF7F33.8020305@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 09:16:03AM +0200, Michal Simek wrote:
> BTW: Where to get musl package

Source is available from http://www.musl-libc.org/. We also have cross
compilers and binaries for a number of archs here:

  https://bitbucket.org/GregorR/musl-cross

However, microblaze was not included since the support in the upstream
GNU packages seemed to be broken/unusable. If this has changed, please
let me know. I'd really like to get microblaze support added added to
the cross-compiler builds.

> and are there any tests we should regularly run?

We have a libc-test package under development here:

  http://nsz.repo.hu/git/?p=libc-test

There's nothing musl-specific about the tests; they can also be run
against glibc, and presumably uClibc too. It's still a bit
experimental now, and still pulling in tests we had in various
non-unified test modules into a proper test framework, but it may be
useful.

Rich
