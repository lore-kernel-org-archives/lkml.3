Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaF1QgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:36:23 -0400
Received: from imap.thunk.org ([74.207.234.97]:34484 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaF1QgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:36:22 -0400
Date: Sat, 28 Jun 2014 12:36:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nick Krause <xerofoify@gmail.com>
Cc: stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup of Kernel Bugzilla
Message-ID: <20140628163618.GC22215@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Nick Krause <xerofoify@gmail.com>, stable@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPDOMVg=L+spebzkckNpM0=9NY=meV=F_+ko+VJN_6M50NdNew@mail.gmail.com>
 <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:45:47PM -0400, Nick Krause wrote:
> Do any of you use the kernel Bugzilla? If you do I was wondering if we
> can clean it up.
> Otherwise I was wondering were  I can get an accurate list of open
> bugs in the newest
> kernels.

Some subsystem maintainers use the kernel bugzilla.  Others do not.
How they use it is also highly variable.  For example, bugs that are
filed with the ext4 component cause mail to be sent to the linux-ext4
mailing list, and replies automatically end up in the bugzilla log.
We use the ext4 bugzilla as a record of the bug, and we'll have a
pointer to the kernel bugzilla URL with the fix.  But we don't always
close out the bug.  Sometimes a few kernel developers will do some
cleanup, but it's not something that done regularly.

Also note that many bugs are never filed via the bugzilla, and are
reported via the mailing list.  So if you want a full and complete
list of open bugs --- sorry, there is no such thing.

     	     	      	     	      	      - Ted
