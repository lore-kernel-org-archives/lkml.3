Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3KFPvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:51:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42411 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KFPvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:51:37 -0500
Date: Wed, 6 Nov 2013 15:51:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [libseccomp-discuss] ARM audit, seccomp, etc are broken wrt
	OABI syscalls
Message-ID: <20131106155104.GZ16735@n2100.arm.linux.org.uk>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com> <1383751951.28218.64.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383751951.28218.64.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:32:31AM -0500, Eric Paris wrote:
> On Tue, 2013-11-05 at 14:36 -0800, Andy Lutomirski wrote:
> > 1. Set a different audit arch for OABI syscalls (e.g.
> > AUDIT_ARCH_ARMOABI).  That is, treat OABI syscall entries the same way
> > that x86_64 treats int 80.
> 
> As the audit maintainer, I like #1.  It might break ABI, but the ABI is
> flat wrong now and not maintainable...

If you read the whole thread, you will see that this corner case is just
not worth the effort to support.  Audit may as well be disabled by
kernel config if any OABI support is enabled.
