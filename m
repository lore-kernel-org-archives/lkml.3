Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab3BZGiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:38:25 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49999 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab3BZGiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:38:24 -0500
Date: Tue, 26 Feb 2013 01:38:13 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226063813.GA17317@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Howells <dhowells@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
	keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
 <CAPM=9tygczL81L_t=uJs3bAae_h96iGkxWK-qYfcWkcCzOjsXw@mail.gmail.com>
 <20130226060428.GD12906@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226060428.GD12906@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here's a further thought, extending on the analogy with closed
graphics hardware which requires proprietary drivers.  We _could_ have
made life easier for users who had the misfortune of purchasing closed
hardware.  We could have tied ourselves in knots and promulgated a
stable kernel ABI, so that Nvidia and ATI/AMD could more easly inflict
proprietary binary blob drivers just like they do for Windows.  We
chose not to screw ourselves over that way, even though it meant that
some users had a harder time of it.

Remember, before Intel came out with their graphics chips, for a while
it seemed that there were very grahpics options with decent
performance available that didn't require propietary drivers.  There
was a while when things looked pretty bleak.  Yet we didn't cave, and
eventually, life got better and more open options came on the scene.

Yet in the case of Secure Boot, everyone is assuming that Windows 8
will be a success, and that Microsoft will continue to dominate x86
client machines, and there will be no significant numbers of machines
that won't be locked down to Microsoft whims.  And so, we should run
up the white flag of surrender, and do everything that Microsoft
_might_ possibly require lest they capriciously and arbitrary decide
to revoke Linux distro's keys.

Linux distributions can do whatever they want, including locking down
kernel ABI's like they did for enterprise kernels (and I don't need to
tell people how painful that was for Linux distros).  But we didn't do
that for upstream kernels; instead, we pushed for open source device
drivers, and open hardware.  It took years, and we're still not 100%
successful, but we've made incredible progress, to the point where
we're no longer stressed out about device drivers any more; we just
avoid the proprietary crap, and it's not so hard to do that.

Maybe there's a lesson to be drawn from that which can be applied to
the Secure Boot mess.

Regards,

						- Ted
