Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaLHWOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:14:14 -0500
Received: from imap.thunk.org ([74.207.234.97]:46180 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbaLHWOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:14:12 -0500
Date: Mon, 8 Dec 2014 17:14:01 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
Message-ID: <20141208221401.GA4991@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
 <20141208164650.GB29028@node.dhcp.inet.fi>
 <20141208175805.GB22149@ZenIV.linux.org.uk>
 <20141208185635.GA25867@node.dhcp.inet.fi>
 <CA+55aFwow9hVqNVGp7gjnnu4=A+J8vw1i22W4e7+1r1-215cHg@mail.gmail.com>
 <20141208192358.GB25867@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208192358.GB25867@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 09:23:58PM +0200, Kirill A. Shutemov wrote:
> > I guess you're running it in a VM, but still.. Doing random system
> > calls as root sounds like a bad bad idea.
> 
> I'm doing this for a long time and didn't see any problem bigger than qemu
> crash[1]. ;)
> 
> [1] http://thread.gmane.org/gmane.comp.emulators.qemu/194845/

If you use something like this:

   -drive file=root_fs.img,if=virtio,snapshot=on

running trinity as root should be quite safe in a VM.  :-)

		   	       	  	- Ted
