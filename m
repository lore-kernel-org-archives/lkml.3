Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaEWQGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:06:52 -0400
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:57009 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaEWQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:06:50 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 12:06:50 EDT
Date: Fri, 23 May 2014 17:57:47 +0200
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Rich Felker <dalias@libc.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Boaz Harrosh <bharrosh@panasas.com>, "Alfred M. Szmidt" <ams@gnu.org>
Subject: Re: [v4, resend] fcntl-linux.h: add new definitions and manual
 updates for open file description locks
Message-ID: <20140523155747.GA14101@domone.podge>
References: <1399124004-5535-1-git-send-email-jlayton@poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399124004-5535-1-git-send-email-jlayton@poochiereds.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 09:33:24AM -0400, Jeff Layton wrote:
> Open file description locks have been merged into the Linux kernel for
> v3.15.  Add the appropriate command-value definitions and an update to
> the manual that describes their usage.
> 
> ChangeLog:
> 
> 2014-04-24  Jeff Layton  <jlayton@poochiereds.net>
> 
> 	[BZ#16839]
> 	* manual/llio.texi: add section about open file description locks
> 
> 	* sysdeps/unix/sysv/linux/bits/fcntl-linux.h:
> 	  (F_OFD_GETLK, F_OFD_SETLK, F_OFD_SETLKW): New macros.
>
 manual/examples/ofdlocks.c entry is missing.
 
Otherwise ok for me, Carlos, Michael do you have additional comments?
