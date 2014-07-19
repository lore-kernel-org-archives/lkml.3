Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaGSVvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:51:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:45419 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbaGSVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:51:14 -0400
Date: Sat, 19 Jul 2014 17:50:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        David Drysdale <drysdale@google.com>
Subject: Re: [PULL] seccomp update (3.17)
Message-ID: <20140719215055.GA5017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
	Julien Tinnes <jln@chromium.org>,
	David Drysdale <drysdale@google.com>
References: <20140718191908.GA20534@www.outflux.net>
 <20140719061658.GK18775@thunk.org>
 <CAGXu5jLjhXz3G-R18a=4U4OqSo8hLdW7OocCcLaEBLfYs=mAtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLjhXz3G-R18a=4U4OqSo8hLdW7OocCcLaEBLfYs=mAtA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 07:49:55AM -0700, Kees Cook wrote:
> 
> No worries -- the only user of the seccomp syscall that I know of is
> the seccomp regression testing suite, and that'd be trivially to fix.
> 
> I would note that the seccomp series includes adding the syscall also
> to ARM and MIPS, so from a collision fixing perspective, it may be
> fewer edits to fix getrandom instead. :)

I've only wired up x86 and x86_64 for getrandom(2) so far.  I had
assumed the ARM and MIPS folks would prefer to wire up new syscalls on
their own...

					- Ted
