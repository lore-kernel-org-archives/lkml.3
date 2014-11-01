Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbaKATmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:42:07 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51268 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760068AbaKATmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:42:04 -0400
X-Originating-IP: 50.43.41.112
Date: Sat, 1 Nov 2014 12:41:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 3/3] x86: Support compiling out userspace I/O (iopl
 and ioperm)
Message-ID: <20141101194151.GA11810@thin>
References: <7159269982aac3b732af2c33a2e3d04e2048bdfb.1414598511.git.josh@joshtriplett.org>
 <9d77d0e4df8feb2cb55fb21689e016a3145cb7f8.1414598511.git.josh@joshtriplett.org>
 <alpine.DEB.2.11.1410292155300.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410292155300.5308@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:00:54PM +0100, Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, Josh Triplett wrote:
> > v3: Eliminated several #ifdefs, and in particular almost all #ifdefs in
> >     .c files, by adding a macro INIT_SET_IOPL_MASK to use in place of
> >     the initializer for set_iopl_mask, and using __maybe_unused rather
> >     than wrapping function definitions in #ifdef.  Rebased on v3.18-rc1.
> >     Recomputed bloat-o-meter.
> 
> Can you please split this patch into smaller pieces?
> 
>     - Seperate the code move to header files
>     - Seperate the macro stuff
>     - Add the #ifdef CONFIG_.... changes

Done; sending v4 now.

- Josh Triplett
