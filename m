Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaDWPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:09:57 -0400
Received: from fencepost.gnu.org ([208.118.235.10]:46479 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaDWPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:09:55 -0400
Date: Wed, 23 Apr 2014 11:09:51 -0400
Message-Id: <E1Wcyo3-0000Eg-UC@fencepost.gnu.org>
From: ams@gnu.org (Alfred M. Szmidt)
To: Jeff Layton <jlayton@redhat.com>
CC: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, dalias@libc.org,
        mtk.manpages@gmail.com, samba-technical@lists.samba.org,
        nfs-ganesha-devel@lists.sourceforge.net, carlos@redhat.com,
        metze@samba.org, hch@infradead.org, bharrosh@panasas.com
In-reply-to: <1398253172-9221-1-git-send-email-jlayton@redhat.com> (message
	from Jeff Layton on Wed, 23 Apr 2014 07:39:32 -0400)
Subject: Re: [RFC][glibc PATCH] fcntl-linux.h: add new definitions and manual updates for open file description locks
Reply-to: ams@gnu.org
References: <1398253172-9221-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   @@ -2890,7 +2894,7 @@ Get flags associated with the open file.  @xref{File Status Flags}.
    Set flags associated with the open file.  @xref{File Status Flags}.

    @item F_GETLK
   -Get a file lock.  @xref{File Locks}.
   +Test a file lock.  @xref{File Locks}.

F_GETLK does get the (first) lock which blocks; it doesn't test for
it.  "Retrieves information about the first blocking lock ..." or
something might be better than the original

   @@ -2898,6 +2902,18 @@ Set or clear a file lock.  @xref{File Locks}.
    @item F_SETLKW
    Like @code{F_SETLK}, but wait for completion.  @xref{File Locks}.

   +@item F_OFD_GETLK
   +Test a open file description lock.  @xref{Open File Description Locks}.
   +Specific to Linux.

Likewise.  You infact write that it does get the lock information
later in the document wrt. F_OFD_GETLK.
