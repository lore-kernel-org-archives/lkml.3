Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3D2DSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 23:18:23 -0400
Received: from ozlabs.org ([203.10.76.45]:46117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab3D2DSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 23:18:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, arjan@infradead.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com
Subject: Re: [PATCH v2] modpost: fix unwanted VMLINUX_SYMBOL_STR expansion
In-Reply-To: <5179089E.3010005@imgtec.com>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp> <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp> <51772CD3.3040405@zytor.com> <51772EBC.1050600@zytor.com> <5177B061.50107@imgtec.com> <51781AD9.7020600@zytor.com> <5179089E.3010005@imgtec.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 29 Apr 2013 11:40:19 +0930
Message-ID: <87y5c2ccj8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> Commit a4b6a77b77ba4f526392612c2365797fab956014 ("module: fix symbol
> versioning with symbol prefixes") broke the MODVERSIONS loading of any
> module using memcmp (e.g. ipv6) on x86_32, as it's defined to
> __builtin_memcmp which is expanded by VMLINUX_SYMBOL_STR. Use
> __VMLINUX_SYMBOL_STR instead which doesn't expand the argument.
>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>
> I've corrected commit message tags for Rusty's convenience.
> Updated Reported-by to include Andy
> Taken the liberty of adding Tetsuo's Tested-by

Applied.

Thanks especially for chasing this: I was away for a few days last week.

Cheers,
Rusty.
