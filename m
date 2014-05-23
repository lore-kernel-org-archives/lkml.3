Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaEWQAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:00:46 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64493 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWQAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:00:44 -0400
Date: Fri, 23 May 2014 12:00:39 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
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
Message-ID: <20140523120039.4f93d871@tlielax.poochiereds.net>
In-Reply-To: <20140523155747.GA14101@domone.podge>
References: <1399124004-5535-1-git-send-email-jlayton@poochiereds.net>
	<20140523155747.GA14101@domone.podge>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 17:57:47 +0200
Ondřej Bílka <neleai@seznam.cz> wrote:

> On Sat, May 03, 2014 at 09:33:24AM -0400, Jeff Layton wrote:
> > Open file description locks have been merged into the Linux kernel for
> > v3.15.  Add the appropriate command-value definitions and an update to
> > the manual that describes their usage.
> > 
> > ChangeLog:
> > 
> > 2014-04-24  Jeff Layton  <jlayton@poochiereds.net>
> > 
> > 	[BZ#16839]
> > 	* manual/llio.texi: add section about open file description locks
> > 
> > 	* sysdeps/unix/sysv/linux/bits/fcntl-linux.h:
> > 	  (F_OFD_GETLK, F_OFD_SETLK, F_OFD_SETLKW): New macros.
> >
>  manual/examples/ofdlocks.c entry is missing.
>  

Oops! Can one of you fix that up, or do you need me to resend?

> Otherwise ok for me, Carlos, Michael do you have additional comments?

-- 
Jeff Layton <jlayton@poochiereds.net>
