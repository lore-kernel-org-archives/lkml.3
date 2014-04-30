Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaD3Act (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:32:49 -0400
Received: from imap.thunk.org ([74.207.234.97]:40743 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaD3Acq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:32:46 -0400
Date: Tue, 29 Apr 2014 20:32:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Marian Marinov <mm@1h.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140430003236.GA6472@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	Andy Lutomirski <luto@amacapital.net>, Marian Marinov <mm@1h.com>,
	containers@lists.linux-foundation.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	lxc-devel <lxc-devel@lists.sourceforge.net>
References: <535FADDA.2070803@1h.com>
 <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
 <20140430001641.GA28969@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430001641.GA28969@ubuntumail>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 12:16:41AM +0000, Serge Hallyn wrote:
> I forget the details, but there was another case where I wanted to
> have the userns which 'owns' the whole fs available.  I guess we'd
> have to check against that instead of using inode_capable.

Yes, that sounds right.

And *please* tell me that that under no circumstances can anyone other
than root@init_user_ns is allowed to use mknod....

						- Ted
